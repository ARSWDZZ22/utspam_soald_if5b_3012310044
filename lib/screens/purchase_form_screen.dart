// lib/screens/purchase_form_screen.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/models/medicine.dart';
import 'package:utspam_soald_if5b_3012310044/models/transaction.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';
import 'package:utspam_soald_if5b_3012310044/providers/transaction_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/helpers.dart';
import 'package:utspam_soald_if5b_3012310044/utils/validators.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_button.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_textfield.dart';

class PurchaseFormScreen extends StatefulWidget {
  final Medicine? medicine; // Bisa null jika dibuka dari menu
  const PurchaseFormScreen({Key? key, this.medicine}) : super(key: key);

  @override
  _PurchaseFormScreenState createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _prescriptionNumberController = TextEditingController();

  PurchaseMethod _purchaseMethod = PurchaseMethod.direct;
  String? _prescriptionImagePath;
  Medicine? _selectedMedicine;

  @override
  void initState() {
    super.initState();
    _selectedMedicine = widget.medicine;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    _prescriptionNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _prescriptionImagePath = pickedFile.path;
      });
    }
  }

  double _calculateTotalPrice() {
    if (_selectedMedicine == null) return 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    return _selectedMedicine!.price * quantity;
  }

  Future<void> _submitOrder() async {
    if (_selectedMedicine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih obat terlebih dahulu')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_purchaseMethod == PurchaseMethod.prescription &&
          _prescriptionImagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unggah foto resep wajib diisi')));
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);

      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        buyerName: authProvider.user?.fullName ?? 'Pembeli',
        medicineName: _selectedMedicine!.name,
        quantity: int.parse(_quantityController.text),
        unitPrice: _selectedMedicine!.price,
        totalPrice: _calculateTotalPrice(),
        date: Helpers.formatDate(DateTime.now()),
        purchaseMethod: _purchaseMethod,
        prescriptionNumber: _prescriptionNumberController.text.isEmpty
            ? null
            : _prescriptionNumberController.text,
        prescriptionImagePath: _prescriptionImagePath,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await transactionProvider.addTransaction(newTransaction);

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.historyRoute,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Pembelian')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown atau cara memilih obat
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Pilih Obat',
                  border: OutlineInputBorder(),
                ),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<Medicine>(
                    value: _selectedMedicine,
                    isExpanded: true,
                    hint: const Text('Pilih obat dari daftar'),
                    items: Medicine.dummyMedicines.map((Medicine medicine) {
                      return DropdownMenuItem<Medicine>(
                        value: medicine,
                        child: Text(
                            '${medicine.name} - ${Helpers.formatCurrency(medicine.price)}'),
                      );
                    }).toList(),
                    onChanged: (Medicine? newValue) {
                      setState(() {
                        _selectedMedicine = newValue;
                      });
                    },
                  ),
                ),
              ),
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
                      onPressed: _pickImage,
                      tooltip: 'Unggah Foto Resep',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Total Harga: ${Helpers.formatCurrency(_calculateTotalPrice())}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              CustomButton(text: 'Proses Pembelian', onPressed: _submitOrder),
            ],
          ),
        ),
      ),
    );
  }
}
