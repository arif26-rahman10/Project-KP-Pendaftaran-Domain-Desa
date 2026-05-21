class ApiConfig {
  static const String baseUrl =
      "https://0a81-2001-448a-1041-8aed-e0a4-bce6-a7ae-3f5f.ngrok-free.app/api";

  static const String storageUrl =
      "https://0a81-2001-448a-1041-8aed-e0a4-bce6-a7ae-3f5f.ngrok-free.app/storage";

  // AUTH
  static const String login = "/login";
  static const String register = "/register";
  static const String notif = "/notifikasi";

  // PROFILE
  static const String profile = "/profile";
  static const String updateProfile = "/profile/update";

  // INSTANSI
  static const String instansi = "/instansi";
  static const String updateInstansi = "/instansi/update";

  // PENGAJUAN
  static const String submitPengajuan = "/pengajuan/submit";
  static const String getPengajuanUser = "/pengajuan/user";
  static const String checkDomain = "/pengajuan/check-domain";

  // PERPANJANGAN
  static const String listDomainAktif = "/perpanjangan/domain";
  static const String ajukanPerpanjangan = "/perpanjangan/ajukan";

  // USER
  static const String lanjutkanPembayaranPerpanjangan =
      "/perpanjangan/lanjutkan";

  // ADMIN
  static const String adminPerpanjangan = "/admin/perpanjangan";
  static const String generateFakturPerpanjangan = "/admin/perpanjangan/faktur";
  static const String aktivasiPerpanjangan = "/admin/perpanjangan/aktivasi";

  // ADMIN
  static const String getPengajuan = "/admin/pengajuan";
  static const String aktivasi = "/admin/aktivasi";
  static const String verifikasi = "/admin/verifikasi";
  static const String adminNotif = "/admin/notifikasi";
  static const String adminDashboard = "/admin/dashboard";

  static String url(String endpoint) => baseUrl + endpoint;
}
