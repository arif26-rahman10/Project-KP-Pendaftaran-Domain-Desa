import 'package:flutter/material.dart';
import '../admin/domain/pdf_network_page.dart';

class BuktiPembayaranPage extends StatelessWidget {
  final String url;

  const BuktiPembayaranPage({
    super.key,
    required this.url,
  });

  bool get isPdf => url.toLowerCase().endsWith('.pdf');

  @override
  Widget build(BuildContext context) {
    if (isPdf) {
      return PdfNetworkPage(
        url: url,
        title: 'Bukti Pembayaran',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Pembayaran'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Gagal memuat bukti pembayaran',
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}