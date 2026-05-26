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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                                        DataCell(Text('$namaDomain')),
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
                                            icon: const Icon(Icons.visibility),
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
  bool isProcessing = false;
  Map<String, dynamic>? faktur;

  @override
  void initState() {
    super.initState();
    loadFaktur();
  }

  Future<void> loadFaktur() async {
    try {
      if (!mounted) return;

      setState(() {
        loading = true;
      });

      final data = await PerpanjanganService.getDetailFaktur(
        widget.idPengajuan,
      );

      if (!mounted) return;

      setState(() {
        // ✅ PENTING: Hanya set faktur jika success == true
        if (data['success'] == true && data['data'] != null) {
          faktur = data['data'] as Map<String, dynamic>;
        } else {
          faktur = null; // ← Pastikan null jika belum ada
        }

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      print('Error loading faktur: $e');

      setState(() {
        faktur = null;
        loading = false;
      });
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Detail Perpanjangan',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ===== INFO SECTION =====
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: kPrimary, width: 4),
                      ),
                      color: Colors.grey.shade50,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Domain', '${widget.namaDomain}.desa.id'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Nama Desa', widget.namaDesa),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== FAKTUR SECTION =====
                  if (faktur != null) ...[
                    Text(
                      'Informasi Faktur',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              'No. Faktur',
                              faktur!['no_invoice'] ?? '-',
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              'Total Pembayaran',
                              'Rp ${(faktur!['total'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              'Status',
                              _getStatusBadge(faktur!['status'] ?? ''),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              'Tanggal Faktur',
                              faktur!['created_at']?.toString().substring(
                                    0,
                                    10,
                                  ) ??
                                  '-',
                            ),
                            if (faktur!['expired_at'] != null)
                              Column(
                                children: [
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    'Tanggal Kadaluarsa',
                                    faktur!['expired_at']?.toString().substring(
                                          0,
                                          10,
                                        ) ??
                                        '-',
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ===== ACTION BUTTONS =====
                  if (faktur == null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isProcessing ? null : () => _buatFaktur(),
                        child: isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Buat Faktur Perpanjangan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )
                  else if (faktur!['status'] == 'belum_bayar')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: null,
                        child: const Text(
                          'Menunggu Pembayaran dari Desa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else if (faktur!['status'] == 'sudah_bayar')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isProcessing
                            ? null
                            : () => _aktivasiDomain(),
                        child: isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Aktivasi Domain Perpanjangan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (faktur != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'Refresh Data',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () => loadFaktur(),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
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
                    color: Colors.black87,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _getStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case 'belum_bayar':
        bgColor = Colors.yellow.shade100;
        textColor = Colors.yellow.shade700;
        label = 'Belum Bayar';
        icon = Icons.schedule;
        break;
      case 'sudah_bayar':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = 'Sudah Bayar';
        icon = Icons.check_circle;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = status;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buatFaktur() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final result = await PerpanjanganService.buatFaktur(widget.idPengajuan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  Future<void> _aktivasiDomain() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final result = await PerpanjanganService.aktivasiPerpanjangan(
        widget.idPengajuan,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }
}
