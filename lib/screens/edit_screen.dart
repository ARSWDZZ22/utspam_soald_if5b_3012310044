// lib/screens/edit_screen.dart

import 'dart:io'; // <-- IMPORT UNTUK MENANGANI FILE
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // <-- IMPORT PACKAGE IMAGE_PICKER
import '../models/user.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class EditScreen extends StatefulWidget {
  final User user;
  final Transaction transaction;

  const EditScreen({Key? key, required this.user, required this.transaction}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker(); // INSTANCE IMAGE_PICKER

  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late TextEditingController _prescriptionNumberController;

  int _quantity = 1;
  String _purchaseMethod = 'Beli Langsung';
  bool _isPrescriptionSelected = false;
  File? _prescriptionImage; // VARIABEL UNTUK MENYIMPAN FILE GAMBAR

  @override
  void initState() {
    super.initState();
    _quantity = widget.transaction.quantity;
    _quantityController = TextEditingController(text: _quantity.toString());
    _notesController = TextEditingController(text: widget.transaction.notes);
    _prescriptionNumberController = TextEditingController(text: widget.transaction.prescriptionNumber ?? '');
    _purchaseMethod = widget.transaction.purchaseMethod;
    _isPrescriptionSelected = (_purchaseMethod == 'Resep Dokter');

    // INISIALISASI GAMBAR RESEP DARI DATA TRANSAKSI YANG ADA
    if (widget.transaction.prescriptionImagePath != null && widget.transaction.prescriptionImagePath!.isNotEmpty) {
      _prescriptionImage = File(widget.transaction.prescriptionImagePath!);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    _prescriptionNumberController.dispose();
    super.dispose();
  }

  double get _totalPrice => widget.transaction.medicine.price * _quantity;

  // FUNGSI UNTUK MEMILIH GAMBAR DARI GALERI
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _prescriptionImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updatePurchase() async {
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

      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        buyerName: widget.transaction.buyerName,
        medicine: widget.transaction.medicine,
        quantity: _quantity,
        notes: _notesController.text,
        purchaseMethod: _purchaseMethod,
        prescriptionNumber: _isPrescriptionSelected ? _prescriptionNumberController.text : null,
        prescriptionImagePath: _prescriptionImage?.path, // SIMPAN PATH GAMBAR BARU
        timestamp: widget.transaction.timestamp,
        status: widget.transaction.status,
      );

      await _storageService.updateTransaction(updatedTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil diperbarui!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Kembali ke Detail dan beri sinyal untuk refresh
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editTitle),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Obat (Read-only)
              Row(
                children: [
                  Image.network(
                    widget.transaction.medicine.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transaction.medicine.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Harga: ${Helpers.formatCurrency(widget.transaction.medicine.price)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                labelText: 'Jumlah',
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = Validators.validateNumeric(value);
                  if (val != null) return val;
                  final qty = int.tryParse(value!);
                  if (qty == null || qty <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
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

              // Pilihan Metode Pembelian
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

              // Total Harga
              Text(
                'Total Harga: ${Helpers.formatCurrency(_totalPrice)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 24),

              CustomButton(text: 'Simpan Perubahan', onPressed: _updatePurchase),
            ],
          ),
        ),
      ),
    );
  }
}