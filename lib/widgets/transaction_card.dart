import 'package:flutter/material.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/utils/helpers.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;
  const TransactionCard(
      {Key? key, required this.transaction, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.receipt_long,
            color: transaction.status == TransactionStatus.canceled
                ? Colors.grey
                : Theme.of(context).colorScheme.primary),
        title: Text(transaction.medicineName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Tanggal: ${transaction.date}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Helpers.formatCurrency(transaction.totalPrice),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 4),
            Text(transaction.status.name.toUpperCase(),
                style: TextStyle(
                    fontSize: 12,
                    color: transaction.status == TransactionStatus.canceled
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
