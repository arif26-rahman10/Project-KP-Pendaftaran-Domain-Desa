import 'package:flutter/material.dart';
import '../main.dart';
import 'detail_domain_page.dart';

class DaftarDomainPage extends StatefulWidget {
  const DaftarDomainPage({super.key});

  @override
  State<DaftarDomainPage> createState() => _DaftarDomainPageState();
}

class _DaftarDomainPageState extends State<DaftarDomainPage> {
  String selectedType = 'Type';

  final List<Map<String, String>> domainList = [
    {
      'namaDomain': 'xxx.desa.id',
      'status': 'Aktif',
      'tipeAplikasi': 'Registrasi',
      'masaAktif': '1 Tahun',
      'tanggalKadaluarsa': '2/11/2019',
      'harga': 'Rp.50.000',
      'detailDomain': '-',
      'buktiPembayaran': 'BuktiPembayaran.pdf',
    },
    {
      'namaDomain': 'xxx.desa.id',
      'status': 'Menunggu Pembayaran',
      'tipeAplikasi': 'Registrasi',
      'masaAktif': '1 Tahun',
      'tanggalKadaluarsa': '2/11/2019',
      'harga': 'Rp.50.000',
      'detailDomain': '-',
      'buktiPembayaran': '-',
    },
    {
      'namaDomain': 'xxx.desa.id',
      'status': 'Nonaktif',
      'tipeAplikasi': 'Registrasi',
      'masaAktif': '1 Tahun',
      'tanggalKadaluarsa': '2/11/2019',
      'harga': 'Rp.50.000',
      'detailDomain': '-',
      'buktiPembayaran': 'BuktiPembayaran.pdf',
    },
    {
      'namaDomain': 'xxx.desa.id',
      'status': 'Kadaluarsa',
      'tipeAplikasi': 'Registrasi',
      'masaAktif': '1 Tahun',
      'tanggalKadaluarsa': '2/11/2019',
      'harga': 'Rp.50.000',
      'detailDomain': '-',
      'buktiPembayaran': '-',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Aktif':
        return const Color(0xFF69C17A);
      case 'Menunggu Pembayaran':
        return const Color(0xFFE6671E);
      case 'Nonaktif':
        return const Color(0xFF9E9E9E);
      case 'Kadaluarsa':
        return const Color(0xFF6F7387);
      default:
        return Colors.grey;
    }
  }

  double _statusWidth(String status) {
    switch (status) {
      case 'Aktif':
        return 70;
      case 'Menunggu Pembayaran':
        return 94;
      case 'Nonaktif':
        return 74;
      case 'Kadaluarsa':
        return 95;
      default:
        return 80;
    }
  }

  double _statusFontSize(String status) {
    if (status == 'Menunggu Pembayaran') {
      return 10;
    }
    return 12;
  }

  void _goToDetail(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailDomainPage(
          namaDomain: item['namaDomain'] ?? '-',
          tipeAplikasi: item['tipeAplikasi'] ?? '-',
          status: item['status'] ?? '-',
          masaAktif: item['masaAktif'] ?? '-',
          tanggalKadaluarsa: item['tanggalKadaluarsa'] ?? '-',
          harga: item['harga'] ?? '-',
          detailDomain: item['detailDomain'] ?? '-',
          buktiPembayaran: item['buktiPembayaran'] ?? '-',
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      width: _statusWidth(status),
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: status == 'Aktif'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 13,
                ),
                SizedBox(width: 4),
                Text(
                  'Aktif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: _statusFontSize(status),
              ),
            ),
    );
  }

  Widget _detailButton(VoidCallback onTap) {
    return SizedBox(
      width: 63,
      height: 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Detail',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2),
            Icon(
              Icons.arrow_forward,
              size: 13,
            ),
          ],
        ),
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
                  'Daftar Domain',
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
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
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
                  const SizedBox(height: 12),

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
                                  value: 'Aktif',
                                  child: Text('Aktif'),
                                ),
                                DropdownMenuItem(
                                  value: 'Menunggu Pembayaran',
                                  child: Text('Menunggu Pembayaran'),
                                ),
                                DropdownMenuItem(
                                  value: 'Nonaktif',
                                  child: Text('Nonaktif'),
                                ),
                                DropdownMenuItem(
                                  value: 'Kadaluarsa',
                                  child: Text('Kadaluarsa'),
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
                    margin: const EdgeInsets.only(top: 0),
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
                                flex: 4,
                                child: Text(
                                  'Status',
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
                        ...domainList.map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
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
                                  flex: 4,
                                  child: Center(
                                    child: _statusBadge(item['status'] ?? '-'),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: _detailButton(
                                      () => _goToDetail(item),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
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