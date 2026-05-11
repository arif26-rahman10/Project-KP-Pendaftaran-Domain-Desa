import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/pengajuan_service.dart';

class DetailNotifikasiPage extends StatelessWidget {
  final String title;
  final String message;

  final int? idPengajuan;

  const DetailNotifikasiPage({
    super.key,
    required this.title,
    required this.message,
    this.idPengajuan,
  });

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    // tombol hanya muncul kalau notif pembayaran
    final showPaymentButton = message.toLowerCase().contains(
      'melanjutkan proses pembayaran',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: Column(
        children: [
          // ================= HEADER =================
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

          // ================= CONTENT =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const Spacer(),

                  // ================= BUTTON =================
                  if (showPaymentButton)
                    SizedBox(
                      width: double.infinity,
                      height: 45,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        onPressed: () async {
                          if (idPengajuan == null) return;

                          try {
                            await PengajuanService().lanjutkanPembayaran(
                              idPengajuan!,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Faktur berhasil dibuat'),
                                ),
                              );

                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },

                        child: const Text(
                          'Lanjutkan Pembayaran',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
