// lib/screens/purchase_form_screen.dart

import 'dart:io'; // <-- IMPORT UNTUK MENANGANI FILE
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // <-- IMPORT PACKAGE IMAGE_PICKER
import '../models/user.dart';
import '../models/medicine.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'history_screen.dart';

class PurchaseFormScreen extends StatefulWidget {
  final User user;
  final Medicine? selectedMedicine;

  const PurchaseFormScreen({Key? key, required this.user, this.selectedMedicine}) : super(key: key);

  @override
  _PurchaseFormScreenState createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker(); // INSTANCE IMAGE_PICKER

  late TextEditingController _buyerNameController;
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late TextEditingController _prescriptionNumberController;

  Medicine? _selectedMedicine;
  int _quantity = 1;
  String _purchaseMethod = 'Beli Langsung';
  bool _isPrescriptionSelected = false;
  File? _prescriptionImage; // VARIABEL UNTUK MENYIMPAN FILE GAMBAR

  final List<Medicine> _dummyMedicines = [
    Medicine(id: '1', name: 'Paracetamol 500mg', imageUrl: 'https://via.placeholder.com/150', price: 5000),
    Medicine(id: '2', name: 'Amoxicillin 500mg', imageUrl: 'https://via.placeholder.com/150/FFC0CB/000000', price: 10000),
    Medicine(id: '3', name: 'Vitamin C 1000mg', imageUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF', price: 7500),
  ];

  @override
  void initState() {
    super.initState();
    _buyerNameController = TextEditingController(text: widget.user.fullName);
    _quantityController = TextEditingController(text: '1');
    _notesController = TextEditingController();
    _prescriptionNumberController = TextEditingController();
    _selectedMedicine = widget.selectedMedicine ?? _dummyMedicines.first;
  }

  @override
  void dispose() {
    _buyerNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    _prescriptionNumberController.dispose();
    super.dispose();
  }

  double get _totalPrice => (_selectedMedicine?.price ?? 0) * _quantity;

  // FUNGSI UNTUK MEMILIH GAMBAR DARI GALERI
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _prescriptionImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPurchase() async {
    if (_formKey.currentState!.validate()) {
      // VALIDASI WAJIB UNGGAH FOTO RESEP
      if (_isPrescriptionSelected && _prescriptionImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto resep wajib diunggah.'), backgroundColor: Colors.red),
        );
        return;
      }
      // VALIDASI WAJIB ISI NOMOR RESEP
      if (_isPrescriptionSelected && _prescriptionNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomor resep wajib diisi.'), backgroundColor: Colors.red),
        );
        return;
      }

      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        buyerName: _buyerNameController.text,
        medicine: _selectedMedicine!,
        quantity: _quantity,
        notes: _notesController.text,
        purchaseMethod: _purchaseMethod,
        prescriptionNumber: _isPrescriptionSelected ? _prescriptionNumberController.text : null,
        prescriptionImagePath: _prescriptionImage?.path, // SIMPAN PATH GAMBAR
        timestamp: DateTime.now(),
        status: 'Aktif',
      );

      await _storageService.saveTransaction(newTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil disimpan!'), backgroundColor: Colors.green),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen(user: widget.user)),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.purchaseTitle),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<Medicine>(
                value: _selectedMedicine,
                decoration: const InputDecoration(labelText: 'Pilih Obat', border: OutlineInputBorder()),
                items: _dummyMedicines.map((Medicine medicine) {
                  return DropdownMenuItem<Medicine>(value: medicine, child: Text(medicine.name));
                }).toList(),
                onChanged: (Medicine? newValue) {
                  setState(() {
                    _selectedMedicine = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(labelText: 'Nama Pembeli', controller: _buyerNameController, validator: Validators.validateNotEmpty),
              CustomTextField(
                labelText: 'Jumlah',
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = Validators.validateNumeric(value);
                  if (val != null) return val;
                  final qty = int.tryParse(value!);
                  if (qty == null || qty <= 0) return 'Jumlah harus lebih dari 0';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _quantity = int.tryParse(value) ?? 1;
                  });
                },
              ),
              CustomTextField(labelText: 'Catatan (Opsional)', controller: _notesController),
              const SizedBox(height: 16),
              const Text('Metode Pembelian:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Beli Langsung'),
                      value: 'Beli Langsung',
                      groupValue: _purchaseMethod,
                      onChanged: (value) {
                        setState(() {
                          _purchaseMethod = value!;
                          _isPrescriptionSelected = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Resep Dokter'),
                      value: 'Resep Dokter',
                      groupValue: _purchaseMethod,
                      onChanged: (value) {
                        setState(() {
                          _purchaseMethod = value!;
                          _isPrescriptionSelected = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // INPUT NOMOR RESEP & UPLOAD FOTO (KONDISIONAL)
              if (_isPrescriptionSelected) ...[
                CustomTextField(
                  labelText: 'Nomor Resep',
                  controller: _prescriptionNumberController,
                  validator: Validators.validatePrescriptionNumber,
                ),
                const SizedBox(height: 8),
                CustomButton(
                  text: _prescriptionImage == null
                      ? 'Pilih Foto Resep'
                      : 'Ubah Foto Resep (${_prescriptionImage!.path.split('/').last})',
                  onPressed: _pickImage,
                ),
                // TAMPILKAN PREVIEW GAMBAR JIKA SUDAH DIPILIH
                if (_prescriptionImage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_prescriptionImage!, fit: BoxFit.cover),
                    ),
                  ),
                const SizedBox(height: 16),
              ],

              Text(
                'Total Harga: ${Helpers.formatCurrency(_totalPrice)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 24),
              CustomButton(text: 'Simpan Transaksi', onPressed: _submitPurchase),
            ],
          ),
        ),
      ),
    );
  }
}