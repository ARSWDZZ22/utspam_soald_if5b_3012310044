// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/validators.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_button.dart';
import 'package:utspam_soald_if5b_3012310044/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await authProvider.login(
          _usernameController.text,
          _passwordController.text,
        );
        if (authProvider.isLoggedIn) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstants.homeRoute,
            (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextfield(
                    controller: _usernameController,
                    label: 'Username',
                    validator: (value) =>
                        FormValidators.validateFieldRequired(value, 'Username'),
                  ),
                  CustomTextfield(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: FormValidators.validatePassword,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Login',
                    onPressed: _login,
                    isLoading: authProvider.isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AppConstants.registerRoute);
                    },
                    child: const Text('Belum punya akun? Daftar di sini'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
