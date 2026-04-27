class Pengajuan {
  final int id;
  final String namaDesa;
  final String domain;
  final String status;
  final String tanggal;

  Pengajuan({
    required this.id,
    required this.namaDesa,
    required this.domain,
    required this.status,
    required this.tanggal,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      id: json['id_pengajuan'],
      namaDesa: json['nama_desa'],
      domain: json['nama_domain'] + ".desa.id",
      status: json['status_pengajuan'],
      tanggal: json['tgl_pengajuan'],
    );
  }
}
