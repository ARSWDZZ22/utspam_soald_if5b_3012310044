// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/models/medicine.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/medicine_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apotek Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.profileRoute);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, ${authProvider.user?.fullName ?? 'Pengguna'}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildMenuCard(context, Icons.shopping_cart, 'Beli Obat', () {
                  Navigator.pushNamed(context, AppConstants.purchaseFormRoute);
                }),
                _buildMenuCard(context, Icons.history, 'Riwayat', () {
                  Navigator.pushNamed(context, AppConstants.historyRoute);
                }),
                _buildMenuCard(context, Icons.person, 'Profil', () {
                  Navigator.pushNamed(context, AppConstants.profileRoute);
                }),
                _buildMenuCard(context, Icons.logout, 'Keluar', () {
                  _showLogoutDialog(context);
                }),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Rekomendasi Obat',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: Medicine.dummyMedicines.length,
                itemBuilder: (context, index) {
                  final medicine = Medicine.dummyMedicines[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MedicineCard(
                      medicine: medicine,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.purchaseFormRoute,
                          arguments: medicine,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}