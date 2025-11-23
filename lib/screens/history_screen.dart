// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/transaction_card.dart';
import 'detail_screen.dart';
import 'home_screen.dart'; // <-- IMPORT UNTUK Navigasi ke Home

class HistoryScreen extends StatefulWidget {
  final User user;

  const HistoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _transactionsFuture = _storageService.getTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.historyTitle),
        backgroundColor: AppColors.primaryGreen,
        // --- TAMBAHKAN TOMBOL KEMBALI KE BERANDA ---
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Kembali ke Beranda',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
              );
            },
          ),
        ],
        // --- AKHIR DARI BAGIAN TAMBAHAN ---
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat transaksi.', style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          final transactions = snapshot.data!;
          transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(
                transaction: transaction,
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(user: widget.user, transaction: transaction)));
                  if (result == true) {
                    _loadTransactions();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}