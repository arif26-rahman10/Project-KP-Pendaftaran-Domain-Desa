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

  String selectedStatus = '';
  final TextEditingController catatan = TextEditingController();

  bool isLoading = false;
  bool sudahSetStatusAwal = false;

  @override
  void initState() {
    super.initState();
    detailFuture = PengajuanService().getDetail(widget.data.id);
  }

  @override
  void dispose() {
    catatan.dispose();
    super.dispose();
  }

  void pilihStatus(String status) {
    setState(() {
      selectedStatus = status;
    });

    debugPrint("STATUS DIPILIH: $selectedStatus");
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
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Ya, Saya Yakin"),
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

    if (selectedStatus == "perlu_perbaikan" && catatan.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Catatan wajib diisi jika perlu perbaikan"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await PengajuanService().verifikasiPengajuan(
        id: item.id,
        status: selectedStatus,
        catatan: catatan.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil verifikasi")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> aktivasiDomain(int id) async {
    setState(() {
      isLoading = true;
    });

    try {
      await PengajuanService().aktivasiDomain(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Domain berhasil diaktifkan")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal aktivasi: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengajuan"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Pengajuan>(
        future: detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = snapshot.data!;

          if (!sudahSetStatusAwal) {
            if (item.status == "diproses" || item.status == "perlu_perbaikan") {
              selectedStatus = item.status;
            } else {
              selectedStatus = "";
            }

            sudahSetStatusAwal = true;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _sectionTitle("Informasi Instansi"),

                _infoTile("Nama Instansi", item.namaDesa),
                _infoTile("Nama Domain", item.domain),
                _infoTile("Tanggal", item.tanggal),
                _infoTile("Status", _statusText(item.status)),

                const SizedBox(height: 10),

                _sectionTitle("Dokumen Persyaratan"),

                _fileTile("Surat Permohonan", "surat_permohonan", item),

                _fileTile(
                  "Perda Pembentukan Desa",
                  "perda_pembentukan_desa",
                  item,
                ),

                _fileTile("Surat Kuasa", "surat_kuasa", item),

                _fileTile(
                  "Surat Penunjukan Pejabat",
                  "surat_penunjukan_pejabat",
                  item,
                ),

                _fileTile("KTP ASN Pejabat", "ktp_asn_pejabat", item),

                const SizedBox(height: 20),

                _verifikasiSection(item),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.blue)),
      trailing: Flexible(
        child: Text(value.isEmpty ? "-" : value, textAlign: TextAlign.end),
      ),
    );
  }

  Widget _fileTile(String title, String type, Pengajuan item) {
    final url = item.dokumenUrls[type];

    final isAvailable = url != null && url.isNotEmpty;

    return ListTile(
      title: Text(title),
      trailing: Text(
        isAvailable ? "Lihat" : "Tidak ada",
        style: TextStyle(color: isAvailable ? Colors.blue : Colors.grey),
      ),
      onTap: isAvailable
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

  Widget _verifikasiSection(Pengajuan item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xfff5f5f5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hasil Verifikasi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 16),

          if (item.status == 'aktif') ...[
            const Center(
              child: Text(
                "Domain sudah aktif dan tidak dapat diubah",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else if (item.status == 'menunggu_aktivasi') ...[
            const Text(
              "Domain siap diaktifkan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

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
                          "Apakah Anda yakin ingin mengaktifkan domain ini?",
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
          ] else ...[
            InkWell(
              onTap: isLoading ? null : () => pilihStatus("diproses"),
              child: Row(
                children: [
                  Radio<String>(
                    value: "diproses",
                    groupValue: selectedStatus,
                    activeColor: Colors.red,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            if (value != null) {
                              pilihStatus(value);
                            }
                          },
                  ),
                  const Expanded(child: Text("Disetujui")),
                ],
              ),
            ),

            InkWell(
              onTap: isLoading ? null : () => pilihStatus("perlu_perbaikan"),
              child: Row(
                children: [
                  Radio<String>(
                    value: "perlu_perbaikan",
                    groupValue: selectedStatus,
                    activeColor: Colors.red,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            if (value != null) {
                              pilihStatus(value);
                            }
                          },
                  ),
                  const Expanded(child: Text("Perlu Perbaikan")),
                ],
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: catatan,
              decoration: const InputDecoration(
                hintText: "Catatan...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

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
                          "Apakah anda yakin ingin mengirim verifikasi ini?",
                        );

                        if (ok) {
                          kirimVerifikasi(item);
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim"),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusText(String status) {
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
}
