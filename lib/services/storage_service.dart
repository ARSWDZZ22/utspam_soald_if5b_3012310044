// lib/services/storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_soald_if5b_3012310044/models/user.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- User Management ---
  static Future<void> saveUser(User user) async {
    String userJson = jsonEncode(user.toJson());
    await _prefs.setString(AppConstants.userDataKey, userJson);
  }

  static User? getUser() {
    String? userJson = _prefs.getString(AppConstants.userDataKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> clearUser() async {
    await _prefs.remove(AppConstants.userDataKey);
  }

  // --- Transaction Management ---
  static Future<void> saveTransaction(Transaction transaction) async {
    List<Transaction> transactions = await getAllTransactions();
    transactions.add(transaction);
    List<String> transactionJsonList =
        transactions.map((t) => jsonEncode(t.toJson())).toList();
    await _prefs.setStringList(
        AppConstants.transactionListKey, transactionJsonList);
  }

  static Future<List<Transaction>> getAllTransactions() async {
    List<String>? transactionJsonList =
        _prefs.getStringList(AppConstants.transactionListKey);
    if (transactionJsonList != null) {
      return transactionJsonList
          .map((json) => Transaction.fromJson(jsonDecode(json)))
          .toList();
    }
    return [];
  }

  static Future<void> updateTransaction(Transaction updatedTransaction) async {
    List<Transaction> transactions = await getAllTransactions();
    int index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      List<String> transactionJsonList =
          transactions.map((t) => jsonEncode(t.toJson())).toList();
      await _prefs.setStringList(
          AppConstants.transactionListKey, transactionJsonList);
    }
  }

  static Future<void> deleteTransaction(String transactionId) async {
    List<Transaction> transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == transactionId);
    List<String> transactionJsonList =
        transactions.map((t) => jsonEncode(t.toJson())).toList();
    await _prefs.setStringList(
        AppConstants.transactionListKey, transactionJsonList);
  }

  static Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
