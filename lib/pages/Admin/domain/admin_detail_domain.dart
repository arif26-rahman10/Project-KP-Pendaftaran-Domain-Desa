import 'package:flutter/material.dart';
import '../../../models/pengajuan_model.dart';
import '../../../services/pengajuan_service.dart';
import 'pdf_network_page.dart';

class DetailDomainPage extends StatefulWidget {
  final Pengajuan data;

  const DetailDomainPage({super.key, required this.data});

  @override
  State<DetailDomainPage> createState() => _DetailDomainPageState();
}

class _DetailDomainPageState extends State<DetailDomainPage> {
  late Future<Pengajuan> detailFuture;

  final TextEditingController catatan = TextEditingController();

  String selectedStatus = '';
  bool isLoading = false;
  bool sudahInitStatus = false;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  void loadDetail() {
    detailFuture = PengajuanService().getDetail(widget.data.id);
  }

  Future<void> refreshPage() async {
    setState(() {
      sudahInitStatus = false;
      loadDetail();
    });
  }

  @override
  void dispose() {
    catatan.dispose();
    super.dispose();
  }

  String normalize(String value) {
    return value.trim().toLowerCase();
  }

  void pilihStatus(String value) {
    setState(() {
      selectedStatus = value;
    });
  }

  Future<bool> showKonfirmasi(String pesan) async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Konfirmasi"),
            content: Text(pesan),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Ya"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> kirimVerifikasi(Pengajuan item) async {
    if (selectedStatus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih status terlebih dahulu")),
      );
      return;
    }

    if (selectedStatus == 'perlu_perbaikan' && catatan.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Catatan wajib diisi")));
      return;
    }

    setState(() => isLoading = true);

    try {
      await PengajuanService().verifikasiPengajuan(
        id: item.id,
        status: selectedStatus,
        catatan: catatan.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Verifikasi berhasil")));

      await refreshPage();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> aktivasiDomain(int id) async {
    setState(() => isLoading = true);

    try {
      await PengajuanService().aktivasiDomain(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Domain berhasil diaktifkan")),
      );

      await refreshPage();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal aktivasi: $e")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Color badgeColor(String status) {
    switch (status) {
      case 'aktif':
        return Colors.green;
      case 'menunggu_aktivasi':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'perlu_perbaikan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'ditinjau':
        return "Menunggu Verifikasi";
      case 'diproses':
        return "Sedang Diproses";
      case 'perlu_perbaikan':
        return "Perlu Perbaikan";
      case 'menunggu_aktivasi':
        return "Menunggu Aktivasi";
      case 'aktif':
        return "Domain Aktif";
      default:
        return status;
    }
  }

  Widget infoTile(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
      ),
      trailing: SizedBox(
        width: 180,
        child: Text(value.isEmpty ? "-" : value, textAlign: TextAlign.end),
      ),
    );
  }

  Widget fileTile(String title, String key, Pengajuan item) {
    final url = item.dokumenUrls[key];
    final tersedia = url != null && url.isNotEmpty;

    return ListTile(
      title: Text(title),
      trailing: Text(
        tersedia ? "Lihat" : "Tidak Ada",
        style: TextStyle(color: tersedia ? Colors.blue : Colors.grey),
      ),
      onTap: tersedia
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfNetworkPage(url: url, title: title),
                ),
              );
            }
          : null,
    );
  }

  Widget buildVerifikasi(Pengajuan item) {
    final status = normalize(item.status);

    if (status == 'aktif') {
      return const Center(
        child: Text(
          "Domain sudah aktif",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (status == 'menunggu_aktivasi') {
      return Column(
        children: [
          const Text(
            "Domain siap diaktifkan",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      final ok = await showKonfirmasi(
                        "Aktifkan domain sekarang?",
                      );

                      if (ok) {
                        await aktivasiDomain(item.id);
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Aktifkan Domain"),
            ),
          ),
        ],
      );
    }

    if (status == 'ditinjau') {
      return Column(
        children: [
          RadioListTile(
            value: 'diproses',
            groupValue: selectedStatus,
            activeColor: Colors.red,
            title: const Text("Disetujui"),
            onChanged: isLoading ? null : (v) => pilihStatus(v.toString()),
          ),
          RadioListTile(
            value: 'perlu_perbaikan',
            groupValue: selectedStatus,
            activeColor: Colors.red,
            title: const Text("Perlu Perbaikan"),
            onChanged: isLoading ? null : (v) => pilihStatus(v.toString()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: catatan,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Catatan...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      final ok = await showKonfirmasi(
                        "Kirim hasil verifikasi?",
                      );

                      if (ok) {
                        await kirimVerifikasi(item);
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Kirim"),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Text(
        statusText(status),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengajuan"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: FutureBuilder<Pengajuan>(
          future: detailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Terjadi kesalahan\n${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }

            if (!snapshot.hasData) {
              return ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text("Data tidak ditemukan")),
                ],
              );
            }

            final item = snapshot.data!;
            final status = normalize(item.status);

            if (!sudahInitStatus) {
              if (status == 'diproses' || status == 'perlu_perbaikan') {
                selectedStatus = status;
              } else {
                selectedStatus = '';
              }

              sudahInitStatus = true;
            }

            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.red,
                  child: const Text(
                    "Informasi Instansi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                infoTile("Nama Instansi", item.namaDesa),
                infoTile("Nama Domain", item.domain),
                infoTile("Tanggal", item.tanggal),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.red,
                  child: const Text(
                    "Informasi Desa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                infoTile("Telepon", item.telepon),
                infoTile("Faksimili", item.faksimili),
                infoTile("Alamat", item.alamat),
                infoTile("Provinsi", item.provinsi),
                infoTile("Kabupaten", item.kotaKabupaten),
                infoTile("Kecamatan", item.kecamatan),
                infoTile("Desa", item.desaKelurahan),
                infoTile("Kode Pos", item.kodePos),

                ListTile(
                  title: const Text(
                    "Status",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor(status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText(status),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.red,
                  child: const Text(
                    "Dokumen Persyaratan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                fileTile("Surat Permohonan", "surat_permohonan", item),
                fileTile(
                  "Perda Pembentukan Desa",
                  "perda_pembentukan_desa",
                  item,
                ),
                fileTile("Surat Kuasa", "surat_kuasa", item),
                fileTile(
                  "Surat Penunjukan Pejabat",
                  "surat_penunjukan_pejabat",
                  item,
                ),
                fileTile("KTP ASN Pejabat", "ktp_asn_pejabat", item),

                const SizedBox(height: 20),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xfff5f5f5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: buildVerifikasi(item),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
