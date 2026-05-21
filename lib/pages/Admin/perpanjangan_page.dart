import 'package:flutter/material.dart';
import '../../main.dart';
import '../../services/perpanjangan_service.dart';

class AdminPerpanjangPage extends StatefulWidget {
  const AdminPerpanjangPage({super.key});

  @override
  State<AdminPerpanjangPage> createState() => _AdminPerpanjangPageState();
}

class _AdminPerpanjangPageState extends State<AdminPerpanjangPage> {
  List<dynamic> requestList = [];
  List<dynamic> filteredList = [];
  bool loading = true;
  String searchQuery = '';
  String selectedStatus = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      if (!mounted) return;

      final data = await PerpanjanganService.getRequestPerpanjangan();

      if (!mounted) return;

      setState(() {
        requestList = data;
        filteredList = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void filterData() {
    setState(() {
      filteredList = requestList.where((item) {
        final domainMatch =
            searchQuery.isEmpty ||
            (item['pengajuan']?['nama_domain'] ?? '')
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

        return domainMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE01925),
        title: const Text(
          'Pengajuan Perpanjang Domain',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
                    Text(
                      'Kelola perpanjangan domain dan status pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ================= SEARCH & FILTER =================
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              searchQuery = value;
                              filterData();
                            },
                            decoration: InputDecoration(
                              hintText: 'Cari Nama Domain...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ================= TABLE =================
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: filteredList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inbox,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Belum ada pengajuan perpanjangan',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFF8FAFC),
                                ),
                                columns: const [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Domain')),
                                  DataColumn(label: Text('Nama Desa')),
                                  DataColumn(label: Text('Tgl Request')),
                                  DataColumn(label: Text('Aksi')),
                                ],
                                rows: List<DataRow>.generate(
                                  filteredList.length,
                                  (index) {
                                    final item = filteredList[index];
                                    final pengajuan = item['pengajuan'];
                                    final namaDomain =
                                        pengajuan?['nama_domain'] ?? '-';
                                    final namaDesa =
                                        pengajuan?['nama_desa'] ?? '-';
                                    final idPengajuan =
                                        pengajuan?['id_pengajuan'] ?? 0;
                                    final createdAt = item['created_at'] ?? '';

                                    return DataRow(
                                      cells: [
                                        DataCell(Text('${index + 1}')),
                                        DataCell(Text('$namaDomain.desa.id')),
                                        DataCell(Text(namaDesa)),
                                        DataCell(
                                          Text(
                                            createdAt.isNotEmpty
                                                ? createdAt.substring(0, 10)
                                                : '-',
                                          ),
                                        ),
                                        DataCell(
                                          ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.visibility,
                                            ), // ← Ganti Icons.eye dengan Icons.visibility
                                            label: const Text('Detail'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kPrimary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                            ),
                                            onPressed: () {
                                              _showDetailModal(
                                                context,
                                                idPengajuan,
                                                namaDomain,
                                                namaDesa,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showDetailModal(
    BuildContext context,
    int idPengajuan,
    String namaDomain,
    String namaDesa,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AdminPerpanjangDetailModal(
        idPengajuan: idPengajuan,
        namaDomain: namaDomain,
        namaDesa: namaDesa,
        onSuccess: () {
          loadData();
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ===== DETAIL MODAL =====
class AdminPerpanjangDetailModal extends StatefulWidget {
  final int idPengajuan;
  final String namaDomain;
  final String namaDesa;
  final VoidCallback onSuccess;

  const AdminPerpanjangDetailModal({
    super.key,
    required this.idPengajuan,
    required this.namaDomain,
    required this.namaDesa,
    required this.onSuccess,
  });

  @override
  State<AdminPerpanjangDetailModal> createState() =>
      _AdminPerpanjangDetailModalState();
}

class _AdminPerpanjangDetailModalState
    extends State<AdminPerpanjangDetailModal> {
  bool loading = true;
  Map<String, dynamic>? faktur;

  @override
  void initState() {
    super.initState();
    loadFaktur();
  }

  Future<void> loadFaktur() async {
    try {
      final data = await PerpanjanganService.getDetailFaktur(
        widget.idPengajuan,
      );

      if (mounted) {
        setState(() {
          faktur = data['data'];
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER =====
                  Text(
                    'Detail Perpanjangan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),

                  // ===== INFO =====
                  _buildInfoRow('Domain', '${widget.namaDomain}.desa.id'),
                  _buildInfoRow('Desa', widget.namaDesa),
                  if (faktur != null) ...[
                    _buildInfoRow('No. Faktur', faktur!['no_faktur'] ?? '-'),
                    _buildInfoRow(
                      'Jumlah',
                      'Rp ${faktur!['jumlah']?.toString() ?? '0'}',
                    ),
                    _buildInfoRow(
                      'Status Faktur',
                      _getStatusBadge(faktur!['status'] ?? ''),
                    ),
                    _buildInfoRow(
                      'Tgl Faktur',
                      faktur!['created_at']?.toString().substring(0, 10) ?? '-',
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ===== ACTION BUTTONS =====
                  if (faktur != null && faktur!['status'] == 'belum_bayar')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _buatFaktur(),
                        child: const Text('Buat Faktur Perpanjangan'),
                      ),
                    )
                  else if (faktur != null &&
                      faktur!['status'] == 'menunggu_verifikasi')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _verifikasiPembayaran(),
                            child: const Text('Verifikasi'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tolak'),
                          ),
                        ),
                      ],
                    )
                  else if (faktur != null && faktur!['status'] == 'sudah_bayar')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _aktivasiDomain(),
                        child: const Text('Aktivasi Domain'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: value is Widget
                ? value
                : Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'belum_bayar':
        bgColor = Colors.yellow.shade100;
        textColor = Colors.yellow.shade700;
        label = 'Belum Bayar';
        break;
      case 'menunggu_verifikasi':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        label = 'Menunggu Verifikasi';
        break;
      case 'sudah_bayar':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = 'Sudah Bayar';
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Future<void> _buatFaktur() async {
    try {
      final result = await PerpanjanganService.buatFaktur(widget.idPengajuan);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _verifikasiPembayaran() async {
    try {
      final result = await PerpanjanganService.verifikasiPembayaran(
        widget.idPengajuan,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
        loadFaktur();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _aktivasiDomain() async {
    try {
      final result = await PerpanjanganService.aktivasiPerpanjangan(
        widget.idPengajuan,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }
}
