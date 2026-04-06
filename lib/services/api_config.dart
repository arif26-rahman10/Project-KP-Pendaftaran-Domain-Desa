class ApiConfig {
  static const bool isLocal = true;

  static const String local = "http://localhost:8000/api";
  static const String production = "https://your-api.com/api";

  static const baseUrl = isLocal ? local : production;

  static const login = "/login";
  static const register = "/register";

  static const submitPengajuan = "/pengajuan/submit";
  static const checkDomain = "/pengajuan/check-domain";
}
