// lib/screens/profile_screen.dart'

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    if (user == null) {
      return const Scaffold(
          body: Center(child: Text('Data pengguna tidak ditemukan.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.fullName.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileItem('Nama Lengkap', user.fullName),
            _buildProfileItem('Email', user.email),
            _buildProfileItem('Nomor Telepon', user.phoneNumber),
            _buildProfileItem('Alamat', user.address),
            _buildProfileItem('Username', user.username),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
