// lib/models/transaction.dart'
import 'package:utspam_soald_if5b_3012310044/utils/helpers.dart';

enum PurchaseMethod { direct, prescription }

enum TransactionStatus { completed, canceled }

class Transaction {
  final String id;
  final String buyerName;
  final String medicineName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String date;
  final PurchaseMethod purchaseMethod;
  final String? prescriptionNumber;
  final String? prescriptionImagePath;
  TransactionStatus status;
  final String? notes;

  Transaction({
    required this.id,
    required this.buyerName,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.date,
    required this.purchaseMethod,
    this.prescriptionNumber,
    this.prescriptionImagePath,
    this.status = TransactionStatus.completed,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerName': buyerName,
      'medicineName': medicineName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'date': date,
      'purchaseMethod': purchaseMethod.name,
      'prescriptionNumber': prescriptionNumber,
      'prescriptionImagePath': prescriptionImagePath,
      'status': status.name,
      'notes': notes,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      buyerName: json['buyerName'],
      medicineName: json['medicineName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
      date: json['date'],
      purchaseMethod: PurchaseMethod.values
          .firstWhere((e) => e.name == json['purchaseMethod']),
      prescriptionNumber: json['prescriptionNumber'],
      prescriptionImagePath: json['prescriptionImagePath'],
      status:
          TransactionStatus.values.firstWhere((e) => e.name == json['status']),
      notes: json['notes'],
    );
  }
}
