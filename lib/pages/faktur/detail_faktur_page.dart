import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/local_auth_service.dart';
import '../../services/pengajuan_service.dart';

import '../../widgets/app_bottom_nav.dart';
import '../../widgets/bukti_sudah_upload_widget.dart';
import '../../widgets/faktur_header_widget.dart';
import '../../widgets/faktur_info_row.dart';
import '../../widgets/rekening_widget.dart';
import '../../widgets/upload_bukti_widget.dart';

import 'bukti_pembayaran_page.dart';
import 'faktur_page.dart';

class DetailFakturPage extends StatefulWidget {
  final int idPengajuan;
  final int idUser;
  final String fullName;
  final String username;

  final String invoiceNumber;
  final String tanggalTerbit;
  final String tanggalKadaluarsa;

  final String namaDomain;
  final String jenisAplikasi;
  final String durasi;
  final String harga;

  final String buktiPembayaranUrl;
  final String fakturStatus;

  const DetailFakturPage({
    super.key,
    required this.idUser,
    required this.idPengajuan,
    required this.fullName,
    required this.username,
    required this.invoiceNumber,
    required this.tanggalTerbit,
    required this.tanggalKadaluarsa,
    required this.namaDomain,
    required this.jenisAplikasi,
    required this.durasi,
    required this.harga,
    this.buktiPembayaranUrl = '',
    this.fakturStatus = '',
  });

  @override
  State<DetailFakturPage> createState() => _DetailFakturPageState();
}

class _DetailFakturPageState extends State<DetailFakturPage> {
  String namaInstansi = '-';
  String emailUser = '-';
  String alamatKantor = '-';

  String namaFile = '';
  File? selectedFile;

  bool isLoading = false;

  bool get buktiSudahDikirim => widget.buktiPembayaranUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = await LocalAuthService.getRegisteredUser();

      if (!mounted) return;

      setState(() {
        namaInstansi = user['namaDesa'] ?? widget.fullName;

        emailUser = user['email'] ?? '-';

        alamatKantor = user['alamat'] ?? '-';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        namaInstansi = widget.fullName;
        emailUser = '-';
        alamatKantor = '-';
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);

        namaFile = result.files.single.name;
      });
    }
  }

  void _showSnackBar({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _kirimBukti() async {
    if (selectedFile == null) {
      _showSnackBar(
        message: 'Pilih file terlebih dahulu',
        color: Colors.red,
        icon: Icons.warning,
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await PengajuanService().uploadBuktiPembayaran(
        idPengajuan: widget.idPengajuan,
        filePath: selectedFile!.path,
      );

      if (!mounted) return;

      _showSnackBar(
        message: 'Bukti pembayaran berhasil dikirim',
        color: Colors.green,
        icon: Icons.check_circle,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FakturPage(
            idUser: widget.idUser,
            fullName: widget.fullName,
            username: widget.username,
          ),
        ),
      );
    } catch (e) {
      _showSnackBar(
        message: 'Upload gagal',
        color: Colors.red,
        icon: Icons.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _lihatBukti() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuktiPembayaranPage(url: widget.buktiPembayaranUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, topSafe + 10, 16, 14),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF9F151B)],
              ),
            ),

            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const SizedBox(width: 12),

                const Text(
                  'Detail Faktur',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  FakturHeaderWidget(
                    invoiceNumber: widget.invoiceNumber,
                    tanggalTerbit: widget.tanggalTerbit,
                    tanggalKadaluarsa: widget.tanggalKadaluarsa,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Instansi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    namaInstansi,
                    style: const TextStyle(
                      color: Color(0xFF3F51B5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(emailUser),

                  const SizedBox(height: 4),

                  Text(alamatKantor),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),

                    child: Column(
                      children: [
                        FakturInfoRow(
                          title: 'Nama Domain',
                          value: widget.namaDomain,
                        ),

                        FakturInfoRow(
                          title: 'Jenis Aplikasi',
                          value: widget.jenisAplikasi,
                        ),

                        FakturInfoRow(title: 'Durasi', value: widget.durasi),

                        FakturInfoRow(title: 'Harga', value: widget.harga),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const RekeningWidget(),

                  const SizedBox(height: 24),

                  buktiSudahDikirim
                      ? BuktiSudahUploadWidget(onLihatBukti: _lihatBukti)
                      : UploadBuktiWidget(
                          isLoading: isLoading,
                          namaFile: namaFile,
                          onPickFile: _pickFile,
                          onUpload: _kirimBukti,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        idUser: widget.idUser,
        fullName: widget.fullName,
        username: widget.username,
      ),
    );
  }
}
