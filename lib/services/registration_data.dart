class RegistrationData {
  String namaDomain = '';

  String namaDesa = '';
  String telepon = '';
  String faksimili = '';
  String alamat = '';
  String kodePos = '';

  String provinsi = '';
  String kotaKabupaten = '';
  String kecamatan = '';
  String desaKelurahan = '';

  Map<String, String> filePaths = {
    "surat_permohonan": "",
    "perda_pembentukan_desa": "",
    "surat_kuasa": "",
    "surat_penunjukan_pejabat": "",
    "ktp_asn_pejabat": "",
  };

  String suratPermohonan = '';
  String perdaPembentukanDesa = '';
  String suratKuasa = '';
  String suratPenunjukan = '';
  String ktpAsnPejabat = '';
}
