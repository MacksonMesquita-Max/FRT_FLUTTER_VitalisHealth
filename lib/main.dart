import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';
import 'package:vitalis_app/components/screens/start/entry_animation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _habitsController = VitalisHabitsController();
  final _userProfileController = VitalisUserProfileController();

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
      builder: (context, child) {
        return VitalisUserProfileScope(
          controller: _userProfileController,
          child: VitalisHabitsScope(
            controller: _habitsController,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const EntryAnimationScreen(),
    );
  }
}
