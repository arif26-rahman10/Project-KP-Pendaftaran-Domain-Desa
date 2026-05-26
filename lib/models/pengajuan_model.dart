import '../services/api_config.dart';

class Pengajuan {
  final int id;
  final int? idUser;
  final String namaDesa;
  final String domain;
  final String tanggal;
  final String status;
  final String catatanUmum;

  final String telepon;
  final String faksimili;
  final String alamat;
  final String provinsi;
  final String kotaKabupaten;
  final String kecamatan;
  final String desaKelurahan;
  final String kodePos;

  final String fakturStatus;
  final String buktiPembayaranUrl;
  final String noInvoice;
  final String totalFaktur;
  final String expiredAt;
  final String tipeFaktur;
  final String tanggalFaktur;

  final Map<String, String> dokumenUrls;

  Pengajuan({
    required this.id,
    this.idUser,
    required this.namaDesa,
    required this.domain,
    required this.tanggal,
    required this.status,
    required this.catatanUmum,
    required this.telepon,
    required this.faksimili,
    required this.alamat,
    required this.provinsi,
    required this.kotaKabupaten,
    required this.kecamatan,
    required this.desaKelurahan,
    required this.kodePos,
    required this.fakturStatus,
    required this.buktiPembayaranUrl,
    required this.noInvoice,
    required this.totalFaktur,
    required this.dokumenUrls,
    required this.expiredAt,
    required this.tipeFaktur,
    required this.tanggalFaktur,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    final Map<String, String> dokumenMap = {};

    if (json['dokumen_persyaratan'] != null) {
      for (var doc in json['dokumen_persyaratan']) {
        final jenis = doc['jenis_dokumen']?.toString() ?? '';
        final path = doc['path_file']?.toString() ?? '';

        if (jenis.isNotEmpty && path.isNotEmpty) {
          dokumenMap[jenis] = "${ApiConfig.storageUrl}/$path";
        }
      }
    }

    String fakturStatus = '';
    String buktiPembayaranUrl = '';
    String noInvoice = '';
    String totalFaktur = '';
    String tipeFaktur = '';
    String tanggalFaktur = '';

    final fakturRaw = json['faktur'];
    Map<String, dynamic>? faktur;

    // ambil faktur terbaru
    if (fakturRaw is List && fakturRaw.isNotEmpty) {
      faktur = Map<String, dynamic>.from(fakturRaw.first);
    }

    if (fakturRaw is Map) {
      faktur = Map<String, dynamic>.from(fakturRaw);
    }

    if (faktur != null) {
      fakturStatus = faktur['status']?.toString() ?? '';
      noInvoice = faktur['no_invoice']?.toString() ?? '';
      totalFaktur = faktur['total']?.toString() ?? '';

      tipeFaktur = faktur['tipe']?.toString() ?? '';

      tanggalFaktur = faktur['created_at']?.toString().substring(0, 10) ?? '';

      final buktiPath = faktur['bukti_pembayaran_path']?.toString() ?? '';

      if (buktiPath.isNotEmpty) {
        buktiPembayaranUrl = "${ApiConfig.storageUrl}/$buktiPath";
      }
    }

    return Pengajuan(
      id: int.tryParse(json['id_pengajuan']?.toString() ?? '') ?? 0,
      idUser: json['id_user'] == null
          ? null
          : int.tryParse(json['id_user'].toString()),
      namaDesa: json['nama_desa']?.toString() ?? '',
      domain: json['nama_domain']?.toString() ?? '',
      tanggal: json['tgl_pengajuan']?.toString() ?? '',
      status: json['status_pengajuan']?.toString() ?? '',
      catatanUmum: json['catatan_umum']?.toString() ?? '',
      telepon: json['telepon']?.toString() ?? '',
      faksimili: json['faksimili']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      provinsi: json['provinsi']?.toString() ?? '',
      kotaKabupaten: json['kota_kabupaten']?.toString() ?? '',
      kecamatan: json['kecamatan']?.toString() ?? '',
      desaKelurahan: json['desa_kelurahan']?.toString() ?? '',
      kodePos: json['kode_pos']?.toString() ?? '',
      fakturStatus: fakturStatus,
      buktiPembayaranUrl: buktiPembayaranUrl,
      noInvoice: noInvoice,
      totalFaktur: totalFaktur,
      expiredAt: faktur?['expired_at']?.toString() ?? '',
      dokumenUrls: dokumenMap,
      tipeFaktur: tipeFaktur,
      tanggalFaktur: tanggalFaktur,
    );
  }
}
