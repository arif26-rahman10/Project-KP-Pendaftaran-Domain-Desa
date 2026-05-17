// widgets/upload_bukti_widget.dart

import 'package:flutter/material.dart';

import '../../../main.dart';

class UploadBuktiWidget extends StatelessWidget {
  final bool isLoading;
  final String namaFile;

  final VoidCallback onPickFile;
  final VoidCallback onUpload;

  const UploadBuktiWidget({
    super.key,
    required this.isLoading,
    required this.namaFile,
    required this.onPickFile,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Bukti Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : onPickFile,
                  child: const Text('Choose File'),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    namaFile.isEmpty ? 'Belum ada file' : namaFile,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: isLoading ? null : onUpload,

            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Kirim Bukti Pembayaran'),
          ),
        ),
      ],
    );
  }
}
