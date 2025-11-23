// lib/utils/helpers.dart

import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  static String formatDate(DateTime date) {
    final format = DateFormat('dd MMMM yyyy', 'id_ID');
    return format.format(date);
  }
}
