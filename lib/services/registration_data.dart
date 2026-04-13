class RegistrationData {
  // ================= DOMAIN =================
  String namaDomain = '';
  bool isDomainAvailable = false;

  // ================= AKUN =================
  String username = '';
  String password = '';
  String name = '';
  String email = '';
  String noHp = '';
  String role = 'desa';

  // ================= DATA DESA =================
  String namaDesa = '';
  String namaKepalaDesa = '';
  String nipKepalaDesa = '';
  String klasifikasiInstansi = 'Pemerintah Desa';

  // ================= KONTAK =================
  String telepon = '';
  String faksimili = '';
  String alamat = '';
  String kodePos = '';

  // ================= WILAYAH =================
  String provinsi = 'Riau';
  String kotaKabupaten = 'Bengkalis';
  String kecamatan = 'Bengkalis';
  String desaKelurahan = 'Kelapapati';

  // ================= FILE =================
  Map<String, String> filePaths = {};

  String suratPermohonan = '';
  String suratKuasa = '';
  String suratPenunjukan = '';
  String kartuPegawai = '';
  String dasarHukum = '';
}
