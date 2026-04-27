import 'package:flutter/material.dart';
import '../models/pengajuan_model.dart';
import '../pages/domain/admin_detail_domain.dart';

class DomainCard extends StatelessWidget {
  final Pengajuan item;
  final VoidCallback onTap;

  const DomainCard({super.key, required this.item, required this.onTap});

  Color getStatusColor(String status) {
    switch (status) {
      case 'ditinjau':
        return Colors.blue;
      case 'diproses':
        return Colors.orange;
      case 'perlu_perbaikan':
        return Colors.red;
      case 'aktif':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'ditinjau':
        return "Menunggu Verifikasi";
      case 'diproses':
        return "Sedang Diproses";
      case 'perlu_perbaikan':
        return "Perlu Perbaikan";
      case 'aktif':
        return "Domain Aktif";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.namaDesa,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                item.tanggal,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // DOMAIN
          Text(
            item.domain,
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),

          const SizedBox(height: 12),

          // STATUS + BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(item.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStatusText(item.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // BUTTON DETAIL
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onPressed: onTap,
                child: const Text("Detail", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
