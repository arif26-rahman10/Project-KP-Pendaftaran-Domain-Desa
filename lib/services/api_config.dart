class ApiConfig {
  static const String baseUrl =
      "https://4e1d-103-166-161-78.ngrok-free.app/api";

  static const String storageUrl =
      "https://4e1d-103-166-161-78.ngrok-free.app/storage";

  // AUTH
  static const String login = "/login";
  static const String register = "/register";

  // PROFILE
  static const String profile = "/profile";
  static const String updateProfile = "/profile/update";

  // INSTANSI
  static const String instansi = "/instansi";
  static const String updateInstansi = "/instansi/update";

  // PENGAJUAN
  static const String submitPengajuan = "/pengajuan/submit";
  static const String getPengajuanUser = "/pengajuan/riwayat";
  static const String checkDomain = "/pengajuan/check-domain";

  // ADMIN
  static const String getPengajuan = "/admin/pengajuan";
  static const String aktivasi = "/admin/aktivasi";
  static const String verifikasi = "/pengajuan/verifikasi";

  static String url(String endpoint) => baseUrl + endpoint;
}
