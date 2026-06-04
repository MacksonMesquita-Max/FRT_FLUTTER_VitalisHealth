import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class SleepHabitSettingsScreen extends StatefulWidget {
  const SleepHabitSettingsScreen({super.key});

  @override
  State<SleepHabitSettingsScreen> createState() => _SleepHabitSettingsScreenState();
}

class _SleepHabitSettingsScreenState extends State<SleepHabitSettingsScreen> {
  double _goalHours = 8;

  String _formatHours(double hours) {
    final fixed = hours.toStringAsFixed(1);
    return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
  }

  Future<void> _confirm() async {
    final goalMinutes = (_goalHours * 60).round();
    VitalisHabitsScope.of(context).setSleepGoalMinutes(goalMinutes);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final goalLabel = '${_formatHours(_goalHours)}h';

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          child: VitalisPrimaryButton(
            label: 'Confirmar Configuração',
            trailing: const Icon(Icons.check_circle_outline, size: 18),
            onPressed: _confirm,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Configuração de Sono',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 160,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'lib/assets/images/sleepForHabits.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.10),
                                      Colors.black.withValues(alpha: 0.60),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.nightlight_round,
                                        size: 16,
                                        color: Color(0xFFBDF3E4),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Foco: Recuperação',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.85),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Defina seu Descanso',
                                    style: textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'O sono de qualidade é a base para sua\nenergia física e mental de amanhã.',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.88),
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.surfaceContainer, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Meta Diária',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF9F0),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      goalLabel,
                                      style: textTheme.labelSmall?.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.secondary,
                                  inactiveTrackColor: AppColors.surfaceContainer,
                                  thumbColor: AppColors.onSurface,
                                  overlayColor: AppColors.secondary.withValues(alpha: 0.12),
                                  trackHeight: 3.5,
                                ),
                                child: Slider(
                                  value: _goalHours,
                                  min: 6,
                                  max: 10,
                                  divisions: 8,
                                  onChanged: (value) => setState(() => _goalHours = value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '6h',
                                      style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                    ),
                                    Text(
                                      '8h',
                                      style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                    ),
                                    Text(
                                      '10h',
                                      style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '“Especialistas recomendam entre 7 e 9 horas\npara adultos.”',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.outline,
                                  height: 1.25,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
