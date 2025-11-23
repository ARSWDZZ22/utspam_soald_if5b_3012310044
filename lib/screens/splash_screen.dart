import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .loadUserFromStorage();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Navigator.pushReplacementNamed(
        context,
        authProvider.isLoggedIn
            ? AppConstants.homeRoute
            : AppConstants.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightColorScheme.primary,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.local_pharmacy,
              size: 100, color: AppTheme.lightColorScheme.onPrimary),
          const SizedBox(height: 20),
          Text('Apotek Mobile',
              style: AppTheme.lightTheme.textTheme.headlineMedium
                  ?.copyWith(color: AppTheme.lightColorScheme.onPrimary)),
          const SizedBox(height: 10),
          Text('Solusi Kesehatan Anda',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightColorScheme.onPrimary.withOpacity(0.8))),
        ]),
      ),
    );
  }
}
