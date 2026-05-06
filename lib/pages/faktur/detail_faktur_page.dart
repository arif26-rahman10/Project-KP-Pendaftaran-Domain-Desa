import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/local_auth_service.dart';
import '../../services/pengajuan_service.dart';
import '../domain/domain_page.dart';
import '../home_page.dart';
import '../users/profile_page.dart';
import 'bukti_pembayaran_page.dart';
import 'faktur_page.dart';

class DetailFakturPage extends StatefulWidget {
  final int idPengajuan;
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
  int currentIndex = 2;

  String namaInstansi = '';
  String emailUser = '';
  String alamatKantor = '';
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

      final idUser = int.tryParse(user['id_user'].toString()) ?? 0;
      final email = user['email']?.toString() ?? 'user@gmail.com';

      if (idUser == 0) {
        if (!mounted) return;

        setState(() {
          namaInstansi = widget.fullName;
          alamatKantor = '-';
          emailUser = email;
        });

        return;
      }

      final response = await ApiService.getInstansi(idUser: idUser);
      final desa = response['desa'];

      if (!mounted) return;

      setState(() {
        namaInstansi = desa?['nama_desa']?.toString() ?? widget.fullName;
        alamatKantor = desa?['alamat']?.toString() ?? '-';
        emailUser = email;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        namaInstansi = widget.fullName;
        alamatKantor = '-';
        emailUser = 'user@gmail.com';
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        namaFile = result.files.single.name;
      });
    }
  }

  void _lihatBuktiPembayaran() {
    if (widget.buktiPembayaranUrl.isEmpty) {
      _showSnackBar(
        message: 'Bukti pembayaran belum tersedia',
        color: Colors.red,
        icon: Icons.warning,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuktiPembayaranPage(url: widget.buktiPembayaranUrl),
      ),
    );
  }

  void _showSnackBar({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        message: 'Silakan pilih file bukti pembayaran terlebih dahulu',
        color: Colors.red,
        icon: Icons.warning,
      );
      return;
    }

    if (widget.idPengajuan == 0) {
      _showSnackBar(
        message: 'ID pengajuan tidak ditemukan',
        color: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    setState(() => isLoading = true);

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

      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FakturPage(fullName: widget.fullName, username: widget.username),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      _showSnackBar(
        message: 'Gagal mengirim bukti pembayaran: $e',
        color: Colors.red,
        icon: Icons.error,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _onTapNav(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomePage(fullName: widget.fullName, username: widget.username),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DomainPage(fullName: widget.fullName, username: widget.username),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FakturPage(fullName: widget.fullName, username: widget.username),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProfilePage(fullName: widget.fullName, username: widget.username),
        ),
      );
    }
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => _onTapNav(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? kPrimary : Colors.grey, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? kPrimary : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF3F51B5), fontSize: 14),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buktiSudahDikirimView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Bukti pembayaran sudah dikirim',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            onPressed: _lihatBuktiPembayaran,
            icon: const Icon(Icons.visibility),
            label: const Text(
              'Lihat Bukti Pembayaran',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadBuktiView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Bukti Pembayaran ',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: isLoading ? null : _pickFile,
                  child: const Text(
                    'Choose File',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    namaFile.isEmpty ? 'Belum ada file dipilih' : namaFile,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: namaFile.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
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
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            onPressed: isLoading ? null : _kirimBukti,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Kirim Bukti Pembayaran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

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
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INVOICE',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.invoiceNumber),
                  const SizedBox(height: 3),
                  Text('Tanggal Terbit : ${widget.tanggalTerbit}'),
                  const SizedBox(height: 3),
                  Text('Tanggal Kadaluarsa : ${widget.tanggalKadaluarsa}'),
                  const SizedBox(height: 18),
                  const Text(
                    'Instansi',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    namaInstansi.isEmpty ? widget.fullName : namaInstansi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3F51B5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(emailUser.isEmpty ? 'user@gmail.com' : emailUser),
                  const SizedBox(height: 3),
                  Text(alamatKantor.isEmpty ? '-' : alamatKantor),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Nama Domain', widget.namaDomain),
                        _buildInfoRow('Jenis Aplikasi', widget.jenisAplikasi),
                        _buildInfoRow('Durasi', widget.durasi),
                        _buildInfoRow('Harga', widget.harga),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Mohon mencantumkan nomor invoice saat melakukan pembayaran.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Silakan lakukan pembayaran melalui transfer ke rekening di bawah ini:',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Diskominfo Bengkalis',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text('Bank BRI'),
                  const SizedBox(height: 3),
                  const Text('Account Number xxxxxxxxxxx'),
                  const SizedBox(height: 18),
                  buktiSudahDikirim
                      ? _buktiSudahDikirimView()
                      : _uploadBuktiView(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          12,
          0,
          bottomSafe > 0 ? bottomSafe : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'Beranda', 0),
            _navItem(Icons.language, 'Domain', 1),
            _navItem(Icons.receipt_long, 'Faktur', 2),
            _navItem(Icons.person_outline, 'Profil', 3),
          ],
        ),
      ),
    );
  }
}
