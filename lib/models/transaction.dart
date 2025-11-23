// lib/models/transaction.dart

import 'medicine.dart';

class Transaction {
  final String id;
  final String buyerName;
  final Medicine medicine;
  final int quantity;
  final String notes;
  final String purchaseMethod; // 'Beli Langsung' or 'Resep Dokter'
  final String? prescriptionNumber; // Opsional
  final String? prescriptionImagePath; // <-- FIELD BARU: Untuk menyimpan path foto resep
  final DateTime timestamp;
  final String status; // 'Aktif', 'Selesai', 'Dibatalkan'

  Transaction({
    required this.id,
    required this.buyerName,
    required this.medicine,
    required this.quantity,
    required this.notes,
    required this.purchaseMethod,
    this.prescriptionNumber,
    this.prescriptionImagePath, // <-- TAMBAHKAN KE CONSTRUCTOR
    required this.timestamp,
    required this.status,
  });

  double get totalPrice => medicine.price * quantity;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      buyerName: json['buyerName'],
      medicine: Medicine(
        id: json['medicine']['id'],
        name: json['medicine']['name'],
        imageUrl: json['medicine']['imageUrl'],
        price: json['medicine']['price'].toDouble(),
      ),
      quantity: json['quantity'],
      notes: json['notes'],
      purchaseMethod: json['purchaseMethod'],
      prescriptionNumber: json['prescriptionNumber'],
      prescriptionImagePath: json['prescriptionImagePath'], // <-- TAMBAHKAN KE fromJson
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerName': buyerName,
      'medicine': {
        'id': medicine.id,
        'name': medicine.name,
        'imageUrl': medicine.imageUrl,
        'price': medicine.price,
      },
      'quantity': quantity,
      'notes': notes,
      'purchaseMethod': purchaseMethod,
      'prescriptionNumber': prescriptionNumber,
      'prescriptionImagePath': prescriptionImagePath, // <-- TAMBAHKAN KE toJson
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}