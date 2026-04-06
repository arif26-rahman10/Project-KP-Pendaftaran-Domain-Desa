import 'package:flutter/material.dart';
import '../../main.dart';
import 'detail_notifikasi_page.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, topSafe + 10, 16, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF8E121A)],
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
                  'Notifikasi',
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              children: [
                _notificationCard(
                  context: context,
                  title: 'Konfirmasi Pembayaran',
                  subtitle:
                      'Pengajuan domain xxx.desa.id telah disetujui.\nApakah Anda ingin melanjutkan proses pembayaran?\nJika ya, sistem akan membuatkan invoice pembayaran.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetailNotifikasiPage(
                          title: 'Konfirmasi Pembayaran',
                          message:
                              'Pengajuan domain xxx.desa.id telah disetujui.\nApakah Anda ingin melanjutkan proses pembayaran?\n\nJika ya, sistem akan membuatkan invoice pembayaran.',
                          leftButtonText: 'Tidak,\nBatalkan',
                          rightButtonText: 'Ya, Lanjutkan Pembayaran',
                        ),
                      ),
                    );
                  },
                ),
                _notificationCard(
                  context: context,
                  title: 'Masa Aktif Domain',
                  subtitle:
                      'Pemberitahuan: Masa aktif domain xxx.desa.id akan berakhir dalam 2 bulan.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetailNotifikasiPage(
                          title: 'Masa Aktif Domain',
                          message:
                              'Pemberitahuan: Masa aktif domain xxx.desa.id akan berakhir dalam 2 bulan.\n\nSilakan lakukan perpanjangan domain sebelum masa berlaku habis agar domain tetap aktif.',
                          leftButtonText: 'Nanti',
                          rightButtonText: 'Perpanjang Sekarang',
                        ),
                      ),
                    );
                  },
                ),
                _notificationCard(
                  context: context,
                  title: 'Faktur Baru',
                  subtitle:
                      'Anda memiliki faktur baru untuk domain xxx.desa.id.\nSilakan melakukan pembayaran sebelum batas waktu yang ditentukan agar proses aktivasi domain dapat dilanjutkan.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetailNotifikasiPage(
                          title: 'Faktur Baru',
                          message:
                              'Anda memiliki faktur baru untuk domain xxx.desa.id.\n\nSilakan melakukan pembayaran sebelum batas waktu yang ditentukan agar proses aktivasi domain dapat dilanjutkan.',
                        ),
                      ),
                    );
                  },
                ),
                _notificationCard(
                  context: context,
                  title: 'Aktivasi Domain',
                  subtitle:
                      'Domain xxx.desa.id telah berhasil diaktifkan.\nDomain sudah dapat digunakan dan masa aktif telah dimulai. Silakan cek detail domain pada menu domain Anda.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetailNotifikasiPage(
                          title: 'Aktivasi Domain',
                          message:
                              'Domain xxx.desa.id telah berhasil diaktifkan.\n\nDomain sudah dapat digunakan dan masa aktif telah dimulai. Silakan cek detail domain pada menu domain Anda.',
                        ),
                      ),
                    );
                  },
                ),
                _notificationCard(
                  context: context,
                  title: 'Perbaikan Dokumen',
                  subtitle:
                      'Dokumen pengajuan domain xxx.desa.id memerlukan perbaikan. Silakan melakukan revisi dokumen sesuai catatan yang diberikan agar proses pengajuan dapat dilanjutkan.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetailNotifikasiPage(
                          title: 'Perbaikan Dokumen',
                          message:
                              'Dokumen pengajuan domain xxx.desa.id memerlukan perbaikan.\n\nSilakan melakukan revisi dokumen sesuai catatan yang diberikan agar proses pengajuan dapat dilanjutkan.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}