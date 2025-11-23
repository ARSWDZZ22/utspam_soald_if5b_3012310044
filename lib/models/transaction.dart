enum PurchaseMethod { direct, prescription }

enum TransactionStatus { completed, canceled }

class Transaction {
  final String id, buyerName, medicineName, date;
  final int quantity;
  final double unitPrice, totalPrice;
  final PurchaseMethod purchaseMethod;
  final String? prescriptionNumber, prescriptionImagePath, notes;
  TransactionStatus status;

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

  Map<String, dynamic> toJson() => {
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

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
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
        status: TransactionStatus.values
            .firstWhere((e) => e.name == json['status']),
        notes: json['notes'],
      );
}
