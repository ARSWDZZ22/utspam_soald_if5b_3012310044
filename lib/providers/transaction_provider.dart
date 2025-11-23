import 'package:flutter/material.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/services/storage_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Future<void> loadTransactions() async {
    _transactions = await StorageService.getAllTransactions();
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // Urutkan terbaru
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await StorageService.saveTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await StorageService.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String transactionId) async {
    await StorageService.deleteTransaction(transactionId);
    await loadTransactions();
  }
}
