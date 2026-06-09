import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';

class SwimmingHabitSettingsScreen extends StatefulWidget {
  const SwimmingHabitSettingsScreen({super.key});

  @override
  State<SwimmingHabitSettingsScreen> createState() => _SwimmingHabitSettingsScreenState();
}

class _SwimmingHabitSettingsScreenState extends State<SwimmingHabitSettingsScreen> {
  double _distanceKm = 5;
  final Set<int> _selectedDaysOfWeek = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final controller = VitalisHabitsScope.of(context);
    final goalMeters = controller.swimmingGoalMeters;
    if (goalMeters != null && goalMeters > 0) {
      _distanceKm = (goalMeters / 1000).clamp(1, 42).toDouble();
    }
    _selectedDaysOfWeek.addAll(controller.swimmingDaysOfWeek);
    _initialized = true;
  }

  String _formatKm(double km) {
    final fixed = km.toStringAsFixed(1);
    return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
  }

  _SwimmingPlan _planForDistance(double km) {
    if (km < 5) return const _SwimmingPlan(intensity: 'Iniciante', forecast: '~30 min');
    if (km <= 10) return const _SwimmingPlan(intensity: 'Moderada', forecast: '1h–1h20');
    if (km <= 20) return const _SwimmingPlan(intensity: 'Intensa', forecast: '2h–3h');
    if (km <= 50) return const _SwimmingPlan(intensity: 'Profissional', forecast: '3h–4h');
    return const _SwimmingPlan(intensity: 'Profissional', forecast: '4h+');
  }

  Future<void> _confirm() async {
    final controller = VitalisHabitsScope.of(context);
    controller.setSwimmingGoalMeters((_distanceKm * 1000).round());
    controller.setSwimmingDaysOfWeek(_selectedDaysOfWeek);
    Navigator.of(context).pop(true);
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDaysOfWeek.contains(day)) {
        _selectedDaysOfWeek.remove(day);
      } else {
        _selectedDaysOfWeek.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final plan = _planForDistance(_distanceKm);

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
                trailing: const Icon(Icons.check, size: 18),
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
                        color: AppColors.onSurface,
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
                        height: 180,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'lib/assets/images/habitsImages/swimingForHabits.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) {
                                  return DecoratedBox(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF0C4A60),
                                          Color(0xFF1D6D86),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.pool_outlined,
                                        size: 56,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  );
                                },
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
                                      Colors.black.withValues(alpha: 0.52),
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
                                    'PERSONALIZE SEU FLUXO',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Defina sua Meta de\nNatação',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Natação é uma forma de exercitar a resistência muscular.',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
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
                                  const Icon(Icons.location_on_outlined, color: AppColors.secondary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Meta de Distância',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _formatKm(_distanceKm),
                                    style: textTheme.titleLarge?.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'km',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.outline,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.secondary,
                                  inactiveTrackColor: AppColors.surfaceContainer,
                                  thumbColor: AppColors.secondary,
                                  overlayColor: AppColors.secondary.withValues(alpha: 0.12),
                                  trackHeight: 3.5,
                                ),
                                child: Slider(
                                  value: _distanceKm,
                                  min: 1,
                                  max: 42,
                                  divisions: 82,
                                  onChanged: (value) => setState(() => _distanceKm = value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '1km',
                                      style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                    ),
                                    Text(
                                      '21km',
                                      style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                    ),
                                    Text(
                                      '42km',
                                      style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'A distância média recomendada para\niniciante é de 5km por sessão.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.outline,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                                  const Icon(Icons.calendar_month_outlined, color: AppColors.secondary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Dias da Semana',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _WeekDayChipButton(
                                    label: 'D',
                                    selected: _selectedDaysOfWeek.contains(7),
                                    onTap: () => _toggleDay(7),
                                  ),
                                  _WeekDayChipButton(
                                    label: 'S',
                                    selected: _selectedDaysOfWeek.contains(1),
                                    onTap: () => _toggleDay(1),
                                  ),
                                  _WeekDayChipButton(
                                    label: 'T',
                                    selected: _selectedDaysOfWeek.contains(2),
                                    onTap: () => _toggleDay(2),
                                  ),
                                  _WeekDayChipButton(
                                    label: 'Q',
                                    selected: _selectedDaysOfWeek.contains(3),
                                    onTap: () => _toggleDay(3),
                                  ),
                                  _WeekDayChipButton(
                                    label: 'Q',
                                    selected: _selectedDaysOfWeek.contains(4),
                                    onTap: () => _toggleDay(4),
                                  ),
                                  _WeekDayChipButton(
                                    label: 'S',
                                    selected: _selectedDaysOfWeek.contains(5),
                                    onTap: () => _toggleDay(5),
                                  ),
                                  _WeekDayChipButton(
                                    label: 'S',
                                    selected: _selectedDaysOfWeek.contains(6),
                                    onTap: () => _toggleDay(6),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Selecione os dias em que você pretende\ntreinar.',
                                textAlign: TextAlign.center,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.outline,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    VitalisReminderTimeField(
                      time: _reminderTime,
                      onChanged: (value) => setState(() => _reminderTime = value),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.bolt,
                            label: 'INTENSIDADE',
                            value: plan.intensity,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.timer_outlined,
                            label: 'PREVISÃO',
                            value: plan.forecast,
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

class _SwimmingPlan {
  const _SwimmingPlan({
    required this.intensity,
    required this.forecast,
  });

  final String intensity;
  final String forecast;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.secondary, size: 18),
              const SizedBox(height: 10),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.outline,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDayChipButton extends StatelessWidget {
  const _WeekDayChipButton({
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
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.surfaceContainer,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: selected ? Colors.white : AppColors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
