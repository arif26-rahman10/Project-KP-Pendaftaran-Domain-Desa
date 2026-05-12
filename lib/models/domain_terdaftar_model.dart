class DomainTerdaftar {
  final int id;
  final String namaDesa;
  final String namaDomain;
  final String status;
  final String tglAktivasi;
  final String masaBerlaku;

  DomainTerdaftar({
    required this.id,
    required this.namaDesa,
    required this.namaDomain,
    required this.status,
    required this.tglAktivasi,
    required this.masaBerlaku,
  });

  factory DomainTerdaftar.fromJson(Map<String, dynamic> json) {
    return DomainTerdaftar(
      id: json['id_pengajuan'] ?? 0,
      namaDesa: json['nama_desa'] ?? '',
      namaDomain: json['nama_domain'] ?? '',
      status: json['status_akt'] ?? '',
      tglAktivasi: json['tgl_aktivasi'] ?? '',
      masaBerlaku: json['masa_berlaku'] ?? '',
    );
  }
}
