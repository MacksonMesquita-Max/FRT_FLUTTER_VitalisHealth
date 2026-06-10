import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class CyclingHabitSettingsScreen extends StatefulWidget {
  const CyclingHabitSettingsScreen({super.key});

  @override
  State<CyclingHabitSettingsScreen> createState() =>
      _CyclingHabitSettingsScreenState();
}

class _CyclingHabitSettingsScreenState extends State<CyclingHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Ciclismo',
    heroSubtitle: 'Pedale com constancia, evolua seu ritmo e acompanhe sua meta.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/ciclismForHabits.png',
  );

  double _distanceKm = 8;
  final Set<int> _selectedDays = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    final goalMeters = controller.cyclingGoalMeters;
    if (goalMeters != null && goalMeters > 0) {
      _distanceKm = (goalMeters / 1000).clamp(1, 60).toDouble();
    }
    _selectedDays.addAll(controller.cyclingDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.cyclingReminderMinutes ?? 1200);
    _initialized = true;
  }

  TimeOfDay _timeFromMinutes(int totalMinutes) {
    final normalized = totalMinutes.clamp(0, 1439);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  int _minutesFromTime(TimeOfDay time) => (time.hour * 60) + time.minute;

  String _formatKm(double km) {
    final fixed = km.toStringAsFixed(1);
    return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
  }

  _CyclingPlan _planForDistance(double km) {
    if (km < 8) return const _CyclingPlan(intensity: 'Leve', forecast: '~25 min');
    if (km <= 20) {
      return const _CyclingPlan(intensity: 'Moderada', forecast: '45min-1h10');
    }
    if (km <= 35) {
      return const _CyclingPlan(intensity: 'Intensa', forecast: '1h20-2h');
    }
    return const _CyclingPlan(intensity: 'Avançada', forecast: '2h+');
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      _daysError = null;
    });
  }

  void _confirm() {
    setState(() {
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });
    if (_daysError != null) return;

    VitalisHabitsScope.of(context).setCyclingPlan(
      goalMeters: (_distanceKm * 1000).round(),
      daysOfWeek: _selectedDays,
      reminderMinutes: _minutesFromTime(_reminderTime),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final plan = _planForDistance(_distanceKm);

    return VitalisHabitSettingsScaffold(
      spec: _spec,
      onConfirm: _confirm,
      confirmTrailing: const Icon(Icons.check_circle_outline, size: 18),
      children: [
        VitalisSettingSliderCard(
          title: 'META DE DISTANCIA',
          valueText: '${_formatKm(_distanceKm)} km',
          value: _distanceKm,
          min: 1,
          max: 60,
          divisions: 118,
          markers: const ['1 km', '30 km', '60 km'],
          onChanged: (value) => setState(() => _distanceKm = value),
          icon: Icons.pedal_bike_outlined,
          helperText: 'Ajuste a distancia ideal para cada sessao de ciclismo.',
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que voce pretende pedalar.',
        ),
        if (_daysError != null) ...[
          const SizedBox(height: 8),
          Text(
            _daysError!,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 18),
        VitalisReminderTimeField(
          time: _reminderTime,
          onChanged: (value) => setState(() => _reminderTime = value),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                icon: Icons.bolt_outlined,
                label: 'INTENSIDADE',
                value: plan.intensity,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                icon: Icons.timer_outlined,
                label: 'TEMPO ESTIMADO',
                value: plan.forecast,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CyclingPlan {
  const _CyclingPlan({
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
