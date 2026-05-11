class ApiConfig {
  static const String baseUrl =
      "https://81f2-2001-448a-1041-e855-fd2b-eb45-c9aa-770d.ngrok-free.app/api";

  static const String storageUrl =
      "https://81f2-2001-448a-1041-e855-fd2b-eb45-c9aa-770d.ngrok-free.app/storage";

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
  static const String getPengajuanUser = "/pengajuan/user";
  static const String checkDomain = "/pengajuan/check-domain";

  // ADMIN
  static const String getPengajuan = "/admin/pengajuan";
  static const String aktivasi = "/admin/aktivasi";
  static const String verifikasi = "/admin/verifikasi";

  static String url(String endpoint) => baseUrl + endpoint;
}
