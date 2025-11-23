// lib/services/storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class StorageService {
  static const _userKey = 'logged_in_user';
  static const _transactionsKey = 'transactions';

  // --- User Operations ---
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // --- Transaction Operations ---
  Future<void> saveTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    transactions.add(transaction);
    // Simpan sebagai string JSON dari list
    await prefs.setString(_transactionsKey, jsonEncode(transactions.map((t) => t.toJson()).toList()));
  }

  Future<void> updateTransaction(Transaction updatedTransaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      await prefs.setString(_transactionsKey, jsonEncode(transactions.map((t) => t.toJson()).toList()));
    }
  }

  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString(_transactionsKey);
    if (transactionsJson != null) {
      final List<dynamic> decodedList = jsonDecode(transactionsJson);
      return decodedList.map((item) => Transaction.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> deleteTransaction(String transactionId) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    transactions.removeWhere((t) => t.id == transactionId);
    await prefs.setString(_transactionsKey, jsonEncode(transactions.map((t) => t.toJson()).toList()));
  }
}