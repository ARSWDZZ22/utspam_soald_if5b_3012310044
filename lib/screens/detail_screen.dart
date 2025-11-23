// lib/screens/detail_screen.dart

import 'dart:io'; // <-- IMPORT UNTUK MENANGANI FILE
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import 'edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final User user;
  final Transaction transaction;

  const DetailScreen({Key? key, required this.user, required this.transaction}) : super(key: key);

  Future<void> _cancelTransaction(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembatalan'),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Tidak')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
        ],
      ),
    );

    if (confirm == true) {
      final storageService = StorageService();
      final updatedTransaction = Transaction(
        id: transaction.id,
        buyerName: transaction.buyerName,
        medicine: transaction.medicine,
        quantity: transaction.quantity,
        notes: transaction.notes,
        purchaseMethod: transaction.purchaseMethod,
        prescriptionNumber: transaction.prescriptionNumber,
        prescriptionImagePath: transaction.prescriptionImagePath, // Jangan lupa field ini
        timestamp: transaction.timestamp,
        status: 'Dibatalkan',
      );
      await storageService.updateTransaction(updatedTransaction);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibatalkan.'), backgroundColor: Colors.red));
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.detailTitle), backgroundColor: AppColors.primaryGreen),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.lightGreen.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text('E-RECEIPT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                  Text('No. Transaksi: #${transaction.id}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Nama Pembeli', transaction.buyerName),
            _buildDetailRow('Tanggal', '${transaction.timestamp.day}-${transaction.timestamp.month}-${transaction.timestamp.year}'),
            _buildDetailRow('Status', transaction.status, textColor: transaction.status == 'Dibatalkan' ? AppColors.red : AppColors.primaryGreen),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.network(transaction.medicine.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.medicine.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${transaction.quantity} x ${Helpers.formatCurrency(transaction.medicine.price)}', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow('Metode Pembelian', transaction.purchaseMethod),
            if (transaction.prescriptionNumber != null) _buildDetailRow('Nomor Resep', transaction.prescriptionNumber!),
            if (transaction.notes.isNotEmpty) _buildDetailRow('Catatan', transaction.notes),

            // --- TAMPILKAN FOTO RESEP JIKA ADA ---
            if (transaction.prescriptionImagePath != null && transaction.prescriptionImagePath!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text('Foto Resep:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(transaction.prescriptionImagePath!),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(height: 250, color: Colors.grey[200], child: const Center(child: Text('Gambar tidak ditemukan.')));
                  },
                ),
              ),
            ],
            // --- AKHIR TAMPILAN FOTO ---

            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL HARGA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(Helpers.formatCurrency(transaction.totalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
              ],
            ),
            const SizedBox(height: 32),
            if (transaction.status != 'Dibatalkan')
              CustomButton(
                text: 'Ubah Pesanan',
                onPressed: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(user: user, transaction: transaction)));
                  if (result == true) {
                    if (context.mounted) Navigator.pop(context, true);
                  }
                },
              ),
            if (transaction.status != 'Dibatalkan') const SizedBox(height: 12),
            CustomButton(
              text: transaction.status == 'Dibatalkan' ? 'Tutup' : 'Batalkan Pesanan',
              onPressed: transaction.status == 'Dibatalkan' ? () => Navigator.pop(context) : () => _cancelTransaction(context),
              color: transaction.status == 'Dibatalkan' ? Colors.grey : AppColors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54))),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: textColor ?? Colors.black))),
        ],
      ),
    );
  }
}