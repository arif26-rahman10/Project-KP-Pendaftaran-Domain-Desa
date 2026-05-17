import 'faktur_model.dart';

class DomainModel {
  final int idPengajuan;
  final String namaDomain;
  final String statusPengajuan;
  final String? statusAktif;
  final String? masaBerlaku;

  // TAMBAHAN
  final List<FakturModel> faktur;

  DomainModel({
    required this.idPengajuan,
    required this.namaDomain,
    required this.statusPengajuan,
    this.statusAktif,
    this.masaBerlaku,

    // TAMBAHAN
    required this.faktur,
  });

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    final aktivasi = json['aktivasi'];

    return DomainModel(
      idPengajuan: json['id_pengajuan'] ?? 0,

      namaDomain: json['nama_domain'] ?? '',

      statusPengajuan: json['status_pengajuan'] ?? '',

      statusAktif: aktivasi != null ? aktivasi['status_akt'] : null,

      masaBerlaku: aktivasi != null ? aktivasi['masa_berlaku'] : null,

      // TAMBAHAN
      faktur:
          (json['faktur'] as List?)
              ?.map((e) => FakturModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
