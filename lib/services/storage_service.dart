import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_soald_if5b_3012310044/models/user.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static Future<void> init() async =>
      _prefs = await SharedPreferences.getInstance();

  static Future<void> saveUser(User user) async {
    await _prefs.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
  }

  static User? getUser() {
    final userJson = _prefs.getString(AppConstants.userDataKey);
    return userJson != null ? User.fromJson(jsonDecode(userJson)) : null;
  }

  static Future<void> clearUser() async =>
      await _prefs.remove(AppConstants.userDataKey);

  static Future<void> saveTransaction(Transaction transaction) async {
    final transactions = await getAllTransactions();
    transactions.add(transaction);
    await _prefs.setStringList(AppConstants.transactionListKey,
        transactions.map((t) => jsonEncode(t.toJson())).toList());
  }

  static Future<List<Transaction>> getAllTransactions() async {
    final list = _prefs.getStringList(AppConstants.transactionListKey);
    return list
            ?.map((json) => Transaction.fromJson(jsonDecode(json)))
            .toList() ??
        [];
  }

  static Future<void> updateTransaction(Transaction updatedTransaction) async {
    final transactions = await getAllTransactions();
    final index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      await _prefs.setStringList(AppConstants.transactionListKey,
          transactions.map((t) => jsonEncode(t.toJson())).toList());
    }
  }

  static Future<void> deleteTransaction(String transactionId) async {
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == transactionId);
    await _prefs.setStringList(AppConstants.transactionListKey,
        transactions.map((t) => jsonEncode(t.toJson())).toList());
  }

  static Future<void> clearAllData() async => await _prefs.clear();
}
