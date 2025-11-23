import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/models/user.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/validators.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_button.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    /* ... dispose controllers ... */ super.dispose();
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
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .register(newUser);
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, AppConstants.homeRoute, (route) => false);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
          appBar: AppBar(title: const Text('Registrasi')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                CustomTextfield(
                    controller: _fullNameController,
                    label: 'Nama Lengkap',
                    validator: (v) => FormValidators.validateFieldRequired(
                        v, 'Nama Lengkap')),
                CustomTextfield(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: FormValidators.validateEmail),
                CustomTextfield(
                    controller: _phoneController,
                    label: 'Nomor Telepon',
                    keyboardType: TextInputType.phone,
                    validator: FormValidators.validatePhoneNumber),
                CustomTextfield(
                    controller: _addressController,
                    label: 'Alamat',
                    maxLines: 3,
                    validator: (v) =>
                        FormValidators.validateFieldRequired(v, 'Alamat')),
                CustomTextfield(
                    controller: _usernameController,
                    label: 'Username',
                    validator: (v) =>
                        FormValidators.validateFieldRequired(v, 'Username')),
                CustomTextfield(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: FormValidators.validatePassword),
                const SizedBox(height: 24),
                CustomButton(
                    text: 'Daftar',
                    onPressed: _register,
                    isLoading: authProvider.isLoading),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppConstants.loginRoute),
                    child: const Text('Sudah punya akun? Masuk di sini')),
              ]),
            ),
          ));
    });
  }
}
