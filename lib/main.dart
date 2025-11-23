// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_soald_if5b_3012310044/providers/auth_provider.dart';
import 'package:utspam_soald_if5b_3012310044/providers/transaction_provider.dart';
import 'package:utspam_soald_if5b_3012310044/screens/detail_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/edit_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/history_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/home_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/login_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/purchase_form_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/register_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/profile_screen.dart';
import 'package:utspam_soald_if5b_3012310044/screens/splash_screen.dart';
import 'package:utspam_soald_if5b_3012310044/services/storage_service.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';
import 'package:utspam_soald_if5b_3012310044/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Apotek Mobile',
        theme: AppTheme.lightTheme,
        initialRoute: AppConstants.splashRoute,
        routes: {
          AppConstants.splashRoute: (context) => const SplashScreen(),
          AppConstants.loginRoute: (context) => const LoginScreen(),
          AppConstants.registerRoute: (context) => const RegisterScreen(),
          AppConstants.homeRoute: (context) => const HomeScreen(),
          AppConstants.purchaseFormRoute: (context) =>
              const PurchaseFormScreen(),
          AppConstants.historyRoute: (context) => const HistoryScreen(),
          AppConstants.detailRoute: (context) => const DetailScreen(),
          AppConstants.editRoute: (context) => const EditScreen(),
          AppConstants.profileRoute: (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
