class ApiConfig {
  static const String baseUrl = "https://pendaftaran.bengkaliskab.go.id/api";

  static const login = "/login";
  static const register = "/register";

  static const submitPengajuan = "/pengajuan/submit";

  static const checkDomain = "/pengajuan/check-domain";

  // ADMIN
  static const getPengajuan = "/admin/pengajuan";
  static const aktivasi = "/admin/aktivasi";
  static const verifikasi = "/pengajuan/verifikasi";
}
