import 'package:flutter/material.dart';
import '../main.dart';
import 'detail_faktur_page.dart';

class DetailDomainPage extends StatelessWidget {
  final String namaDomain;
  final String tipeAplikasi;
  final String status;
  final String masaAktif;
  final String tanggalKadaluarsa;
  final String harga;
  final String detailDomain;
  final String buktiPembayaran;

  const DetailDomainPage({
    super.key,
    required this.namaDomain,
    required this.tipeAplikasi,
    required this.status,
    required this.masaAktif,
    required this.tanggalKadaluarsa,
    required this.harga,
    required this.detailDomain,
    required this.buktiPembayaran,
  });

  Color _statusColor() {
    switch (status) {
      case 'Aktif':
        return const Color(0xFF69C17A);
      case 'Menunggu Pembayaran':
        return const Color(0xFFE6671E);
      case 'Nonaktif':
        return const Color(0xFF8E8E94);
      case 'Kadaluarsa':
        return const Color(0xFF5C6B7A);
      default:
        return Colors.grey;
    }
  }

  double _statusWidth() {
    switch (status) {
      case 'Aktif':
        return 62;
      case 'Menunggu Pembayaran':
        return 120;
      case 'Nonaktif':
        return 85;
      case 'Kadaluarsa':
        return 95;
      default:
        return 80;
    }
  }

  double _statusFontSize() {
    if (status == 'Menunggu Pembayaran') {
      return 10;
    }
    return 12;
  }

  Widget _buildStatusBadge() {
    if (status == 'Aktif') {
      return Container(
        width: _statusWidth(),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: _statusColor(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 12,
            ),
            SizedBox(width: 3),
            Text(
              'Aktif',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: _statusWidth(),
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _statusColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: _statusFontSize(),
        ),
      ),
    );
  }

  Widget _tableRow({
    required String title,
    required Widget valueWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF4B5BD7),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: valueWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textValue(String value) {
    return Text(
      value,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _aksiButton(BuildContext context) {
    String text = '';
    VoidCallback? onPressed;

    if (status == 'Menunggu Pembayaran') {
      text = 'Lihat Invoice';
      onPressed = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DetailFakturPage(
              fullName: 'Pengguna',
              username: 'user',
              invoiceNumber: 'INV-023',
              tanggalTerbit: 'xx/xx/xxxx',
              tanggalKadaluarsa: 'xx/xx/xxxx',
              namaDomain: 'xxx.desa.id',
              jenisAplikasi: 'Registrasi',
              durasi: '1 Tahun',
              harga: 'Rp.50.000',
            ),
          ),
        );
      };
    } else if (status == 'Kadaluarsa') {
      text = 'Invoice Baru';
      onPressed = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DetailFakturPage(
              fullName: 'Pengguna',
              username: 'user',
              invoiceNumber: 'INV-024',
              tanggalTerbit: 'xx/xx/xxxx',
              tanggalKadaluarsa: 'xx/xx/xxxx',
              namaDomain: 'xxx.desa.id',
              jenisAplikasi: 'Perpanjangan',
              durasi: '1 Tahun',
              harga: 'Rp.50.000',
            ),
          ),
        );
      };
    } else {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD94C4C),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    final bool showAksi =
        status == 'Menunggu Pembayaran' || status == 'Kadaluarsa';

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
                  'Detail Domain',
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
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Domain',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFAF252B),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Informasi Domain',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            children: [
                              _tableRow(
                                title: 'Nama Domain',
                                valueWidget: _textValue(namaDomain),
                              ),
                              _tableRow(
                                title: 'Tipe Aplikasi',
                                valueWidget: _textValue(tipeAplikasi),
                              ),
                              _tableRow(
                                title: 'Status',
                                valueWidget: _buildStatusBadge(),
                              ),
                              _tableRow(
                                title: 'Masa Aktif',
                                valueWidget: _textValue(masaAktif),
                              ),
                              _tableRow(
                                title: 'Tanggal Kadaluarsa',
                                valueWidget: _textValue(tanggalKadaluarsa),
                              ),
                              _tableRow(
                                title: 'Harga',
                                valueWidget: _textValue(harga),
                              ),
                              _tableRow(
                                title: 'Detail Domain',
                                valueWidget: _textValue(detailDomain),
                              ),
                              _tableRow(
                                title: 'Bukti Pembayaran',
                                valueWidget: _textValue(buktiPembayaran),
                              ),
                              if (showAksi)
                                _tableRow(
                                  title: 'Aksi',
                                  valueWidget: _aksiButton(context),
                                ),
                            ],
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