import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class GymHabitSettingsScreen extends StatefulWidget {
  const GymHabitSettingsScreen({super.key});

  @override
  State<GymHabitSettingsScreen> createState() => _GymHabitSettingsScreenState();
}

class _GymHabitSettingsScreenState extends State<GymHabitSettingsScreen> {
  double _durationMinutes = 45;
  VitalisGymIntensity _intensity = VitalisGymIntensity.moderada;
  VitalisGymFocus _focus = VitalisGymFocus.cardio;
  final Set<int> _selectedDays = {};
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final controller = VitalisHabitsScope.of(context);
    _durationMinutes = (controller.gymDurationMinutes ?? 45).clamp(15, 120).toDouble();
    _intensity = controller.gymIntensity ?? VitalisGymIntensity.moderada;
    _focus = controller.gymFocus ?? VitalisGymFocus.cardio;
    _selectedDays.addAll(controller.gymDaysOfWeek);
    _initialized = true;
  }

  String _intensityLabel(VitalisGymIntensity intensity) {
    return switch (intensity) {
      VitalisGymIntensity.leve => 'Leve',
      VitalisGymIntensity.moderada => 'Moderada',
      VitalisGymIntensity.intensa => 'Intensa',
    };
  }

  String _focusLabel(VitalisGymFocus focus) {
    return switch (focus) {
      VitalisGymFocus.forca => 'Força',
      VitalisGymFocus.cardio => 'Cardio',
      VitalisGymFocus.flexibilidade => 'Flexibilidade',
    };
  }

  IconData _focusIcon(VitalisGymFocus focus, {required int size}) {
    return switch (focus) {
      VitalisGymFocus.forca => Icons.fitness_center_outlined,
      VitalisGymFocus.cardio => Icons.favorite_border,
      VitalisGymFocus.flexibilidade => Icons.self_improvement_outlined,
    };
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _confirm() async {
    VitalisHabitsScope.of(context).setGymPlan(
      durationMinutes: _durationMinutes.round(),
      intensity: _intensity,
      focus: _focus,
      daysOfWeek: _selectedDays,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VitalisPrimaryButton(
                label: 'Confirmar Configuração',
                onPressed: _confirm,
              ),
              const SizedBox(height: 10),
              Text(
                'Você pode atualizar essas configurações a qualquer momento em seu perfil.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                  height: 1.2,
                ),
              ),
            ],
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
                      'Vitalis',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w900,
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
                        height: 195,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'lib/assets/images/gymForHabits.png',
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
                                      Colors.black.withValues(alpha: 0.06),
                                      Colors.black.withValues(alpha: 0.45),
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
                                  Text(
                                    'PERSONALIZE SEU FLUXO',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Configure seu Treino',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'A disciplina e a chave para o progresso.',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      height: 1.2,
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
                    _SectionCard(
                      title: 'Dias da Semana',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _WeekDayButton(
                                label: 'D',
                                selected: _selectedDays.contains(7),
                                onTap: () => _toggleDay(7),
                              ),
                              _WeekDayButton(
                                label: 'S',
                                selected: _selectedDays.contains(1),
                                onTap: () => _toggleDay(1),
                              ),
                              _WeekDayButton(
                                label: 'T',
                                selected: _selectedDays.contains(2),
                                onTap: () => _toggleDay(2),
                              ),
                              _WeekDayButton(
                                label: 'Q',
                                selected: _selectedDays.contains(3),
                                onTap: () => _toggleDay(3),
                              ),
                              _WeekDayButton(
                                label: 'Q',
                                selected: _selectedDays.contains(4),
                                onTap: () => _toggleDay(4),
                              ),
                              _WeekDayButton(
                                label: 'S',
                                selected: _selectedDays.contains(5),
                                onTap: () => _toggleDay(5),
                              ),
                              _WeekDayButton(
                                label: 'S',
                                selected: _selectedDays.contains(6),
                                onTap: () => _toggleDay(6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Duração do Treino',
                      trailing: Text(
                        '${_durationMinutes.round()} min',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.secondary,
                              inactiveTrackColor: AppColors.surfaceContainer,
                              thumbColor: AppColors.secondary,
                              overlayColor: AppColors.secondary.withValues(alpha: 0.12),
                              trackHeight: 3.5,
                            ),
                            child: Slider(
                              value: _durationMinutes,
                              min: 15,
                              max: 120,
                              divisions: 21,
                              onChanged: (value) => setState(() => _durationMinutes = value),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '15 min',
                                style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                              ),
                              Text(
                                '120 min',
                                style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Intensidade',
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ChoiceButton(
                            label: 'Leve',
                            selected: _intensity == VitalisGymIntensity.leve,
                            onTap: () => setState(() => _intensity = VitalisGymIntensity.leve),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ChoiceButton(
                            label: 'Moderada',
                            selected: _intensity == VitalisGymIntensity.moderada,
                            onTap: () => setState(() => _intensity = VitalisGymIntensity.moderada),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ChoiceButton(
                            label: 'Intensa',
                            selected: _intensity == VitalisGymIntensity.intensa,
                            onTap: () => setState(() => _intensity = VitalisGymIntensity.intensa),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Foco do Treino',
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FocusCard(
                            label: _focusLabel(VitalisGymFocus.forca),
                            icon: _focusIcon(VitalisGymFocus.forca, size: 18),
                            selected: _focus == VitalisGymFocus.forca,
                            onTap: () => setState(() => _focus = VitalisGymFocus.forca),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FocusCard(
                            label: _focusLabel(VitalisGymFocus.cardio),
                            icon: _focusIcon(VitalisGymFocus.cardio, size: 18),
                            selected: _focus == VitalisGymFocus.cardio,
                            onTap: () => setState(() => _focus = VitalisGymFocus.cardio),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FocusCard(
                            label: _focusLabel(VitalisGymFocus.flexibilidade),
                            icon: _focusIcon(VitalisGymFocus.flexibilidade, size: 18),
                            selected: _focus == VitalisGymFocus.flexibilidade,
                            onTap: () => setState(() => _focus = VitalisGymFocus.flexibilidade),
                          ),
                        ),
                      ],
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.trailing,
    required this.child,
  });

  final String title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
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
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDayButton extends StatelessWidget {
  const _WeekDayButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : AppColors.surfaceContainerLow,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: selected ? Colors.white : AppColors.outline,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: selected ? AppColors.secondary : Colors.white,
        foregroundColor: selected ? Colors.white : AppColors.onSurface,
        side: BorderSide(
          color: selected ? AppColors.secondary : AppColors.surfaceContainer,
          width: 1.2,
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      onPressed: onTap,
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
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

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.secondary : AppColors.surfaceContainer,
              width: selected ? 1.6 : 1,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
