class FakturModel {
  final int id;
  final String noInvoice;
  final String namaDesa;
  final String namaDomain;
  final String status;
  final String tipe;
  final String tanggal;
  final String buktiPembayaran;
  final String expiredAt;

  FakturModel({
    required this.id,
    required this.noInvoice,
    required this.namaDesa,
    required this.namaDomain,
    required this.status,
    required this.tipe,
    required this.tanggal,
    required this.buktiPembayaran,
    required this.expiredAt,
  });

  factory FakturModel.fromJson(Map<String, dynamic> json) {
    return FakturModel(
      id: json['id'] ?? 0,

      noInvoice: json['no_invoice'] ?? '',

      namaDesa: json['nama_desa'] ?? '',

      namaDomain: json['nama_domain'] ?? '',

      status: json['status'] ?? '',

      tipe: json['tipe'] ?? '',

      tanggal: json['tanggal_konfirmasi'] ?? '',

      buktiPembayaran: json['bukti_pembayaran'] ?? '',

      expiredAt: json['expired_at'] ?? '',
    );
  }
}
