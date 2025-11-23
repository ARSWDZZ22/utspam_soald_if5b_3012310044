// lib/screens/history_screen.dart'

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/providers/transaction_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/transaction_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
        automaticallyImplyLeading: false, // Tidak ada tombol back
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat pembelian.'),
            );
          }
          return ListView.builder(
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              return TransactionCard(
                transaction: transaction,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppConstants.detailRoute,
                    arguments: transaction,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
