class ApiConfig {
  static const String baseUrl =
<<<<<<< HEAD
      "https://trade-lusty-doorbell.ngrok-free.dev/api";

  static const String storageUrl =
      "https://trade-lusty-doorbell.ngrok-free.dev/storage";
=======
      "https://ed1c-103-166-161-146.ngrok-free.app/api";

  static const String storageUrl =
      "https://ed1c-103-166-161-146.ngrok-free.app/storage";
>>>>>>> 8e0cfca2877ce19352f8ec6a651f9a1dc5e76b72

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
