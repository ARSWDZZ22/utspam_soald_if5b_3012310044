// lib/utils/validators.dart

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    // --- PERUBAHAN DIMULAI DI SINI ---
    // Periksa apakah email berakhir dengan @gmail.com
    if (!value.endsWith('@gmail.com')) {
      return 'Hanya alamat email @gmail.com yang diperbolehkan.';
    }
    // --- PERUBAHAN SELESAI DI SINI ---

    // Anda bisa membiarkan validasi regex umum di bawah ini sebagai cadangan,
    // atau menghapusnya karena pemeriksaan 'endsWith' sudah cukup spesifik.
    // Saya akan membiarkannya untuk keamanan tambahan.
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  static String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini tidak boleh kosong';
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return 'Hanya angka yang diperbolehkan';
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

  static String? validatePrescriptionNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor resep tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Nomor resep minimal 6 karakter';
    }
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return 'Hanya huruf dan angka yang diperbolehkan';
    }
    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini tidak boleh kosong';
    }
    return null;
  }
}