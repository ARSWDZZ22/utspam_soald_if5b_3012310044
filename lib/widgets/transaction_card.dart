// lib/widgets/transaction_card.dart

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          transaction.medicine.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, color: Colors.grey);
          },
        ),
        title: Text(
          transaction.medicine.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${transaction.quantity} x ${Helpers.formatCurrency(transaction.medicine.price)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Helpers.formatCurrency(transaction.totalPrice),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction.status,
              style: TextStyle(
                fontSize: 12,
                color: transaction.status == 'Dibatalkan' ? AppColors.red : AppColors.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}