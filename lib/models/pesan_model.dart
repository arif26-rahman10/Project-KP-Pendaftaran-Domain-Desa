class PesanModel {
  final int id;
  final String judul;
  final String isi;
  final String roleTujuan;
  final int isRead;
  final String createdAt;

  PesanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.roleTujuan,
    required this.isRead,
    required this.createdAt,
  });

  factory PesanModel.fromJson(Map<String, dynamic> json) {
    return PesanModel(
      id: json['id'],
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      roleTujuan: json['role_tujuan'] ?? '',
      isRead: json['is_read'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
