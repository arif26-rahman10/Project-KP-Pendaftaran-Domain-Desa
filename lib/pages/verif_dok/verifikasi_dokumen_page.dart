import 'package:flutter/material.dart';
import '../../main.dart';
import '../../data/verifikasi_dokumen_data.dart';
import 'detail_verifikasi_dokumen_page.dart';

class VerifikasiDokumenPage extends StatefulWidget {
  const VerifikasiDokumenPage({super.key});

  @override
  State<VerifikasiDokumenPage> createState() => _VerifikasiDokumenPageState();
}

class _VerifikasiDokumenPageState extends State<VerifikasiDokumenPage> {
  String selectedType = 'Type';

  List<Map<String, dynamic>> get dokumenList =>
      VerifikasiDokumenData.dokumenList;

  Color _statusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFF69C17A);
      case 'Ditinjau':
        return const Color(0xFFF59B23);
      case 'Perlu Perbaikan':
        return const Color(0xFFE8262A);
      case 'Draft':
        return const Color(0xFF5D6B7B);
      default:
        return Colors.grey;
    }
  }

  double _statusWidth(String status) {
    switch (status) {
      case 'Disetujui':
        return 92;
      case 'Ditinjau':
        return 92;
      case 'Perlu Perbaikan':
        return 116;
      case 'Draft':
        return 74;
      default:
        return 80;
    }
  }

  Widget _statusBadge(String status) {
    if (status == 'Disetujui') {
      return Container(
        width: _statusWidth(status),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: _statusColor(status),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 13),
            SizedBox(width: 4),
            Text(
              'Disetujui',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Container(
      width: _statusWidth(status),
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _aksiButtonBlue(Map<String, dynamic> item) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF29A8F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => DetailVerifikasiDokumenPage(
                id: item['id'],
                status: item['status'],
              ),
            ),
          );

          if (result == true && mounted) {
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dokumen berhasil dikirim')),
            );
          } else {
            setState(() {});
          }
        },
        icon: const Icon(
          Icons.description_outlined,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _aksiButtonRed(int id) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF32626),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Hapus Draft'),
              content: const Text('Yakin ingin menghapus draft ini?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      VerifikasiDokumenData.deleteItem(id);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Draft dihapus')),
                    );
                  },
                  child: const Text('Hapus'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, topSafe + 10, 16, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF861018)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Verifikasi Dokumen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 22, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Daftar Domain',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9E9EB),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedType,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Type',
                                  child: Text('Type'),
                                ),
                                DropdownMenuItem(
                                  value: 'Disetujui',
                                  child: Text('Disetujui'),
                                ),
                                DropdownMenuItem(
                                  value: 'Ditinjau',
                                  child: Text('Ditinjau'),
                                ),
                                DropdownMenuItem(
                                  value: 'Perlu Perbaikan',
                                  child: Text('Perlu Perbaikan'),
                                ),
                                DropdownMenuItem(
                                  value: 'Draft',
                                  child: Text('Draft'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value ?? 'Type';
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E2E4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  'Nama Domain',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6F7387),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  'Status Dokumen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6F7387),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Aksi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6F7387),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...dokumenList.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    item['namaDomain'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: _statusBadge(item['status'] ?? '-'),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _aksiButtonBlue(item),
                                        if (item['showDelete'] == true) ...[
                                          const SizedBox(width: 6),
                                          _aksiButtonRed(item['id']),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Page 1 | 1 of 1',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                        const Text(
                          '1',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD9DCE3),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '2',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD9DCE3),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
