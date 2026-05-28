import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/screens/start/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitalis Health',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          surface: AppColors.background,
          onSurface: AppColors.onSurface,
          outline: AppColors.outline,
        ),
      ),
      home: const StartScreen(),
    );
  }
}
