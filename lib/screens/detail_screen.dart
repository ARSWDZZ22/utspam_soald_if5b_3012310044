// lib/screens/detail_screen.dart'

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/providers/transaction_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/helpers.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_button.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  void _cancelTransaction(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Transaksi'),
        content:
            const Text('Apakah Anda yakin ingin membatalkan transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final updatedTransaction = Transaction(
                id: transaction.id,
                buyerName: transaction.buyerName,
                medicineName: transaction.medicineName,
                quantity: transaction.quantity,
                unitPrice: transaction.unitPrice,
                totalPrice: transaction.totalPrice,
                date: transaction.date,
                purchaseMethod: transaction.purchaseMethod,
                prescriptionNumber: transaction.prescriptionNumber,
                prescriptionImagePath: transaction.prescriptionImagePath,
                status: TransactionStatus.canceled,
                notes: transaction.notes,
              );
              Provider.of<TransactionProvider>(context, listen: false)
                  .updateTransaction(updatedTransaction);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction =
        ModalRoute.of(context)!.settings.arguments as Transaction;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('ID Transaksi', transaction.id),
            _buildDetailRow('Nama Pembeli', transaction.buyerName),
            _buildDetailRow('Nama Obat', transaction.medicineName),
            _buildDetailRow('Jumlah', '${transaction.quantity} pcs'),
            _buildDetailRow(
                'Harga Satuan', Helpers.formatCurrency(transaction.unitPrice)),
            _buildDetailRow(
                'Total Biaya', Helpers.formatCurrency(transaction.totalPrice),
                isBold: true),
            _buildDetailRow('Tanggal Pembelian', transaction.date),
            _buildDetailRow('Metode Pembelian',
                transaction.purchaseMethod.name.toUpperCase()),
            if (transaction.purchaseMethod == PurchaseMethod.prescription) ...[
              if (transaction.prescriptionNumber != null)
                _buildDetailRow('Nomor Resep', transaction.prescriptionNumber!),
              if (transaction.prescriptionImagePath != null)
                _buildDetailRow('File Resep',
                    transaction.prescriptionImagePath!.split('/').last),
            ],
            if (transaction.notes != null && transaction.notes!.isNotEmpty)
              _buildDetailRow('Catatan', transaction.notes!),
            _buildDetailRow('Status', transaction.status.name.toUpperCase(),
                textColor: transaction.status == TransactionStatus.canceled
                    ? Colors.red
                    : Colors.green),
            const SizedBox(height: 30),
            if (transaction.status == TransactionStatus.completed) ...[
              CustomButton(
                text: 'Edit Transaksi',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppConstants.editRoute,
                    arguments: transaction,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            CustomButton(
              text: transaction.status == TransactionStatus.completed
                  ? 'Batalkan Transaksi'
                  : 'Hapus Transaksi',
              onPressed: () {
                if (transaction.status == TransactionStatus.completed) {
                  _cancelTransaction(context, transaction);
                } else {
                  // Logika hapus jika status sudah dibatalkan
                  Provider.of<TransactionProvider>(context, listen: false)
                      .deleteTransaction(transaction.id);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
