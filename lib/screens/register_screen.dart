// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      await _storageService.saveUser(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.registerTitle),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Nama Lengkap',
                controller: _fullNameController,
                validator: Validators.validateNotEmpty,
                prefixIcon: Icons.person,
              ),
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                prefixIcon: Icons.email,
              ),
              CustomTextField(
                labelText: 'No. Telepon',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.validateNumeric,
                prefixIcon: Icons.phone,
              ),
              CustomTextField(
                labelText: 'Alamat',
                controller: _addressController,
                validator: Validators.validateNotEmpty,
                prefixIcon: Icons.home,
              ),
              CustomTextField(
                labelText: 'Username',
                controller: _usernameController,
                validator: Validators.validateNotEmpty,
                prefixIcon: Icons.account_circle,
              ),
              CustomTextField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: true,
                validator: Validators.validatePassword,
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Daftar',
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}