// lib/screens/profile_screen.dart'

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profileTitle),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.lightGreen,
                child: Icon(Icons.person, size: 50, color: AppColors.white),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileItem('Nama Lengkap', user.fullName),
            _buildProfileItem('Email', user.email),
            _buildProfileItem('No. Telepon', user.phoneNumber),
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
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}