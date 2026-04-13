class RegistrationData {
  String domainName = '';
  bool isDomainAvailable = false;

  String username = '';
  String password = '';
  String name = '';
  String email = '';
  String noHp = '';
  String role = 'desa'; // Default role

  // ================= DATA DESA (Profil Desa) =================
  String namaDesa = '';
  String namaKepalaDesa = '';
  String nipKepalaDesa = '';
  String klasifikasiInstansi = 'Pemerintah Desa'; // Default value

  // Kontak Desa
  String telepon = '';
  String faksimili = '';
  String alamat = '';
  String kodePos = '';

  // Wilayah
  String provinsi = 'Riau';
  String kotaKabupaten = 'Bengkalis';
  String kecamatan = 'Bengkalis';
  String desaKelurahan = 'Kelapapati';

  // Files (Dokumen)
  Map<String, String> filePaths = {};
  String suratPermohonan = 'Upload Dokumen.pdf';
  String suratKuasa = 'Upload Dokumen.pdf';
  String suratPenunjukan = 'Upload Dokumen.pdf';
  String kartuPegawai = 'Upload Dokumen.pdf';
  String dasarHukum = 'Upload Dokumen.pdf';
}
