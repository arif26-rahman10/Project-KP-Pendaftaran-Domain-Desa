class VerifikasiDokumenData {
  static List<Map<String, dynamic>> dokumenList = [
    {
      'id': 1,
      'namaDomain': 'xxx.desa.id',
      'status': 'Disetujui',
      'showDelete': false,
    },
    {
      'id': 2,
      'namaDomain': 'xxx.desa.id',
      'status': 'Ditinjau',
      'showDelete': false,
    },
    {
      'id': 3,
      'namaDomain': 'xxx.desa.id',
      'status': 'Perlu Perbaikan',
      'showDelete': false,
    },
    {
      'id': 4,
      'namaDomain': 'xxx.desa.id',
      'status': 'Draft',
      'showDelete': true,
    },
  ];

  static void updateStatus(int id, String newStatus) {
    final index = dokumenList.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      dokumenList[index]['status'] = newStatus;
      dokumenList[index]['showDelete'] = newStatus == 'Draft';
    }
  }

  static void deleteItem(int id) {
    dokumenList.removeWhere((item) => item['id'] == id);
  }
}
