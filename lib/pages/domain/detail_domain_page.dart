import 'package:flutter/material.dart';

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
    switch (status.toLowerCase()) {
      case 'aktif':
        return const Color(0xFF69C17A);

      case 'diproses':
        return const Color(0xFFE6671E);

      case 'perlu_perbaikan':
        return const Color(0xFFD94C4C);

      case 'menunggu_aktivasi':
        return const Color(0xFF4B5BD7);

      default:
        return Colors.grey;
    }
  }

  double _statusWidth() {
    switch (status.toLowerCase()) {
      case 'aktif':
        return 62;

      case 'diproses':
        return 140;

      case 'perlu_perbaikan':
        return 120;

      case 'menunggu_aktivasi':
        return 130;

      default:
        return 90;
    }
  }

  double _statusFontSize() {
    if (status.toLowerCase() == 'diproses') return 10;
    return 12;
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'ditinjau':
        return 'Ditinjau';

      case 'diproses':
        return 'Menunggu Konfirmasi';

      case 'perlu_perbaikan':
        return 'Perlu Perbaikan';

      case 'menunggu_aktivasi':
        return 'Menunggu Aktivasi';

      case 'aktif':
        return 'Aktif';

      default:
        return status;
    }
  }

  Widget _buildStatusBadge() {
    if (status.toLowerCase() == 'aktif') {
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
            Icon(Icons.check_circle_outline, color: Colors.white, size: 12),
            SizedBox(width: 3),
            Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 11)),
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
        statusLabel,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: _statusFontSize()),
      ),
    );
  }

  Widget _tableRow({required String title, required Widget valueWidget}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF4B5BD7), fontSize: 13),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
      style: const TextStyle(fontSize: 14, color: Colors.black87),
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
          // ================= HEADER =================
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

          // ================= CONTENT =================
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
                        // ================= TITLE =================
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

                        // ================= TABLE =================
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
