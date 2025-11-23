// lib/utils/validators.dart

class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor telepon hanya boleh berisi angka';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  static String? validateFieldRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }
    if (int.tryParse(value) == null) {
      return 'Jumlah harus berupa angka';
    }
    if (int.parse(value) <= 0) {
      return 'Jumlah harus lebih dari 0';
    }
    return null;
  }

  static String? validatePrescriptionNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor resep tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Nomor resep minimal 6 karakter';
    }
    final prescriptionRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    if (!prescriptionRegex.hasMatch(value)) {
      return 'Nomor resep harus kombinasi huruf dan angka';
    }
    return null;
  }
}
