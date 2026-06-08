import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';

class HabitSettingsPlaceholderScreen extends StatelessWidget {
  const HabitSettingsPlaceholderScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
          child: Column(
            children: [
              Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Configuração de $title',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Configuração deste hábito em breve.',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.outline,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
