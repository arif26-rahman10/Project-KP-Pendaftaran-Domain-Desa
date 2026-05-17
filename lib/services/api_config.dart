class ApiConfig {
  static const String baseUrl =
      "https://ff49-2001-448a-1041-2f82-f46a-786e-a9e8-f241.ngrok-free.app/api";

  static const String storageUrl =
      "https://ff49-2001-448a-1041-2f82-f46a-786e-a9e8-f241.ngrok-free.app/storage";

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

  // ADMIN
  static const String getPengajuan = "/admin/pengajuan";
  static const String aktivasi = "/admin/aktivasi";
  static const String verifikasi = "/admin/verifikasi";
  static const String adminNotif = "/admin/notifikasi";

  static String url(String endpoint) => baseUrl + endpoint;
}
