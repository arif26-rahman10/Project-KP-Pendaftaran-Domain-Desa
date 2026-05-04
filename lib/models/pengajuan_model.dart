import '../services/api_config.dart';

class Pengajuan {
  final int id;
  final int? idUser;
  final String namaDesa;
  final String domain;
  final String tanggal;
  final String status;
  final Map<String, String> dokumenUrls;

  Pengajuan({
    required this.id,
    this.idUser,
    required this.namaDesa,
    required this.domain,
    required this.tanggal,
    required this.status,
    required this.dokumenUrls,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    Map<String, String> dokumenMap = {};

    if (json['dokumen_persyaratan'] != null) {
      for (var doc in json['dokumen_persyaratan']) {
        dokumenMap[doc['jenis_dokumen']] =
            "${ApiConfig.storageUrl}/${doc['path_file']}";
      }
    }

    return Pengajuan(
      id: json['id_pengajuan'] ?? 0,
      idUser: json['id_user'],
      namaDesa: json['nama_desa'] ?? '',
      domain: json['nama_domain'] ?? '',
      tanggal: json['tgl_pengajuan'] ?? '',
      status: json['status_pengajuan'] ?? '',
      dokumenUrls: dokumenMap,
    );
  }
}
