// lib/main.dart

import 'package:flutter/material.dart';

import 'package:utspam_soald_if5b_3012310044/screens/splash_screen.dart';
import 'package:utspam_soald_if5b_3012310044/utils/constants.dart';

void main() {
  runApp(const ApotekMobileApp());
}

class ApotekMobileApp extends StatelessWidget {
  const ApotekMobileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.0),
          ),
          labelStyle: TextStyle(color: AppColors.darkGrey),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
