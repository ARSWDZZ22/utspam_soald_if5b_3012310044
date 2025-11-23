// lib/screens/edit_screen.dart'

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/providers/transaction_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/helpers.dart';
import 'package:utspam_soald_if5b_3012310044/utils/validators.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_button.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_textfield.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late TextEditingController _prescriptionNumberController;

  late PurchaseMethod _purchaseMethod;
  String? _prescriptionImagePath;
  late Transaction _originalTransaction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _originalTransaction =
        ModalRoute.of(context)!.settings.arguments as Transaction;

    _quantityController =
        TextEditingController(text: _originalTransaction.quantity.toString());
    _notesController =
        TextEditingController(text: _originalTransaction.notes ?? '');
    _prescriptionNumberController = TextEditingController(
        text: _originalTransaction.prescriptionNumber ?? '');
    _purchaseMethod = _originalTransaction.purchaseMethod;
    _prescriptionImagePath = _originalTransaction.prescriptionImagePath;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    _prescriptionNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (_purchaseMethod == PurchaseMethod.prescription &&
          _prescriptionImagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unggah foto resep wajib diisi')));
        return;
      }

      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);

      final updatedTransaction = Transaction(
        id: _originalTransaction.id,
        buyerName: _originalTransaction.buyerName,
        medicineName: _originalTransaction.medicineName,
        quantity: int.parse(_quantityController.text),
        unitPrice: _originalTransaction.unitPrice,
        totalPrice: _originalTransaction.unitPrice *
            int.parse(_quantityController.text),
        date: _originalTransaction.date,
        purchaseMethod: _purchaseMethod,
        prescriptionNumber: _prescriptionNumberController.text.isEmpty
            ? null
            : _prescriptionNumberController.text,
        prescriptionImagePath: _prescriptionImagePath,
        status: _originalTransaction.status,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await transactionProvider.updateTransaction(updatedTransaction);

      if (!mounted) return;
      Navigator.pop(context); // Kembali ke detail screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Obat: ${_originalTransaction.medicineName}',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              CustomTextfield(
                controller: _quantityController,
                label: 'Jumlah Pembelian',
                keyboardType: TextInputType.number,
                validator: FormValidators.validateQuantity,
              ),
              CustomTextfield(
                controller: _notesController,
                label: 'Catatan Tambahan (Opsional)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text('Metode Pembelian',
                  style: Theme.of(context).textTheme.bodyLarge),
              RadioListTile<PurchaseMethod>(
                title: const Text('Pembelian Langsung'),
                value: PurchaseMethod.direct,
                groupValue: _purchaseMethod,
                onChanged: (value) => setState(() => _purchaseMethod = value!),
              ),
              RadioListTile<PurchaseMethod>(
                title: const Text('Pembelian dengan Resep Dokter'),
                value: PurchaseMethod.prescription,
                groupValue: _purchaseMethod,
                onChanged: (value) => setState(() => _purchaseMethod = value!),
              ),
              if (_purchaseMethod == PurchaseMethod.prescription) ...[
                CustomTextfield(
                  controller: _prescriptionNumberController,
                  label: 'Nomor Resep Dokter',
                  validator: FormValidators.validatePrescriptionNumber,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(_prescriptionImagePath?.split('/').last ??
                          'Belum ada file dipilih'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: () async {
                        // TODO: Implement image picker again if needed
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Fitur unggah ulang tidak diimplementasikan pada edit')));
                      },
                      tooltip: 'Unggah Foto Resep',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Total Harga: ${Helpers.formatCurrency(_originalTransaction.unitPrice * (int.tryParse(_quantityController.text) ?? 0))}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              CustomButton(text: 'Simpan Perubahan', onPressed: _saveChanges),
            ],
          ),
        ),
      ),
    );
  }
}
