class ApiConfig {
  static const String baseUrl =
      "https://41a2-2001-448a-1041-c18d-7419-687a-23d-acaa.ngrok-free.app/api";

  static const String storageUrl =
      "https://41a2-2001-448a-1041-c18d-7419-687a-23d-acaa.ngrok-free.app/storage";

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
