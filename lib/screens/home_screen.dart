import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/medicine.dart';
import '../utils/constants.dart';
import '../widgets/medicine_card.dart';
import 'purchase_form_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart'; // Impor untuk navigasi ke halaman login
import '../services/storage_service.dart'; // Impor untuk mengelola data penyimpanan

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  // Data dummy untuk obat dengan URL gambar yang baru
  final List<Medicine> dummyMedicines = [
    Medicine(
        id: '1',
        name: 'Paracetamol 500mg',
        imageUrl: 'https://ik.imagekit.io/arswdz22/apotik/Paracetamol.webp',
        price: 5000),
    Medicine(
        id: '2',
        name: 'Amoxicillin 500mg',
        imageUrl: 'https://ik.imagekit.io/arswdz22/apotik/amoxilin.jpg',
        price: 10000),
    Medicine(
        id: '3',
        name: 'Vitamin C 1000mg',
        imageUrl:
            'https://ik.imagekit.io/arswdz22/apotik/Vitamin%20100%20Mg.webp',
        price: 7500),
    Medicine(
        id: '4',
        name: 'OBH Batuk',
        imageUrl: 'https://ik.imagekit.io/arswdz22/apotik/OBH.png',
        price: 25000),
    Medicine(
        id: '5',
        name: 'Bodrex Flu',
        imageUrl: 'https://ik.imagekit.io/arswdz22/apotik/Bodrek.jpg',
        price: 12000),
    Medicine(
        id: '6',
        name: 'Antangin',
        imageUrl: 'https://ik.imagekit.io/arswdz22/apotik/Antangin.jpg',
        price: 8000),
  ];

  /// Fungsi untuk menangani proses logout pengguna.
  /// Fungsi ini akan:
  /// 1. Mengarahkan pengguna kembali ke halaman Login.
  /// 2. Membersihkan tumpukan navigasi (stack) agar pengguna tidak bisa kembali
  ///    ke halaman sebelumnya (seperti Home, Profile, dll) dengan tombol 'Back'.
  /// 3. TIDAK menghapus data pengguna, sehingga mereka bisa login lagi nanti.
  void _logout() async {
    // Pastikan widget masih aktif sebelum melakukan navigasi
    if (mounted) {
      // Arahkan ke LoginScreen dan hapus semua halaman sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        // Kondisi (Route<dynamic> route) => false memastikan SEMUA
        // halaman sebelumnya dihapus dari stack.
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        backgroundColor: AppColors.primaryGreen,
        // Menghilangkan tombol 'Back' otomatis yang biasanya muncul
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Sapaan
            Text(
              'Halo, ${widget.user.fullName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 20),

            // Menu Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  icon: Icons.shopping_cart,
                  title: 'Beli Obat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PurchaseFormScreen(user: widget.user)),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.history,
                  title: 'Riwayat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HistoryScreen(user: widget.user)),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.person,
                  title: 'Profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(user: widget.user)),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: _logout, // Panggil fungsi _logout saat tombol ditekan
                  color: AppColors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Katalog Obat
            const Text(
              'Katalog Obat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: dummyMedicines.length,
              itemBuilder: (context, index) {
                final medicine = dummyMedicines[index];
                return MedicineCard(
                  medicine: medicine,
                  onBuy: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchaseFormScreen(
                          user: widget.user,
                          selectedMedicine: medicine,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget builder untuk membuat kartu menu di halaman beranda.
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.primaryGreen,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
