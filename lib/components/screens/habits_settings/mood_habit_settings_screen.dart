import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class MoodHabitSettingsScreen extends StatefulWidget {
  const MoodHabitSettingsScreen({super.key});

  @override
  State<MoodHabitSettingsScreen> createState() => _MoodHabitSettingsScreenState();
}

class _MoodHabitSettingsScreenState extends State<MoodHabitSettingsScreen> {
  int _lastWeekLevel = 2;
  VitalisMoodGoalMethod _method = VitalisMoodGoalMethod.manterCalma;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final controller = VitalisHabitsScope.of(context);
    _lastWeekLevel = (controller.moodLastWeekLevel ?? 2).clamp(0, 4);
    _method = controller.moodGoalMethod ?? VitalisMoodGoalMethod.manterCalma;
    _initialized = true;
  }

  int _targetLevel() {
    if (_lastWeekLevel <= 0) return 0;
    return switch (_method) {
      VitalisMoodGoalMethod.manterCalma => (_lastWeekLevel - 1).clamp(0, 4),
      VitalisMoodGoalMethod.aumentarEnergia => 0,
      VitalisMoodGoalMethod.reduzirAnsiedade => (_lastWeekLevel - 2).clamp(0, 4),
    };
  }

  _MoodOption _optionForLevel(int level) {
    return switch (level.clamp(0, 4)) {
      0 => const _MoodOption(label: 'Radiante', icon: Icons.sentiment_very_satisfied),
      1 => const _MoodOption(label: 'Feliz', icon: Icons.sentiment_satisfied),
      2 => const _MoodOption(label: 'Calmo', icon: Icons.sentiment_neutral),
      3 => const _MoodOption(label: 'Ansioso', icon: Icons.sentiment_dissatisfied),
      _ => const _MoodOption(label: 'Triste', icon: Icons.sentiment_very_dissatisfied),
    };
  }

  Future<void> _confirm() async {
    VitalisHabitsScope.of(context).setMoodPlan(
      lastWeekLevel: _lastWeekLevel,
      method: _method,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final target = _optionForLevel(_targetLevel());

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
                      'Configuração de Humor',
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
                        height: 150,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'lib/assets/images/smileForHabits.png',
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
                                      Colors.black.withValues(alpha: 0.40),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Como você se\nsente?',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.90),
                                      fontWeight: FontWeight.w900,
                                      height: 1.12,
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
                    Text(
                      'Passo 1 de 2',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.outline,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Humor da Última Semana',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.surfaceContainer, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              final level = index;
                              final option = _optionForLevel(level);
                              return _MoodChip(
                                label: option.label,
                                icon: option.icon,
                                selected: _lastWeekLevel == level,
                                onTap: () => setState(() => _lastWeekLevel = level),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Passo 2 de 2',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.outline,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sua Meta de Bem-estar',
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(target.icon, size: 16, color: AppColors.secondary),
                              const SizedBox(width: 6),
                              Text(
                                target.label,
                                style: textTheme.labelSmall?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _GoalMethodCard(
                      selected: _method == VitalisMoodGoalMethod.manterCalma,
                      icon: Icons.spa_outlined,
                      title: 'Manter a calma',
                      subtitle: 'Foco em reduzir picos de estresse\ndiários.',
                      onTap: () => setState(() => _method = VitalisMoodGoalMethod.manterCalma),
                    ),
                    const SizedBox(height: 10),
                    _GoalMethodCard(
                      selected: _method == VitalisMoodGoalMethod.aumentarEnergia,
                      icon: Icons.flash_on_outlined,
                      title: 'Aumentar a energia',
                      subtitle: 'Práticas para combater o cansaço\nmental.',
                      onTap: () => setState(() => _method = VitalisMoodGoalMethod.aumentarEnergia),
                    ),
                    const SizedBox(height: 10),
                    _GoalMethodCard(
                      selected: _method == VitalisMoodGoalMethod.reduzirAnsiedade,
                      icon: Icons.self_improvement_outlined,
                      title: 'Reduzir ansiedade',
                      subtitle: 'Aprender técnicas de respiração e\npresença.',
                      onTap: () => setState(() => _method = VitalisMoodGoalMethod.reduzirAnsiedade),
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

class _MoodOption {
  const _MoodOption({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF9F0) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.surfaceContainer,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.secondary : AppColors.onSurface,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalMethodCard extends StatelessWidget {
  const _GoalMethodCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.secondary : AppColors.surfaceContainer,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFEAF9F0) : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(icon, color: AppColors.secondary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.outline,
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
    );
  }
}
