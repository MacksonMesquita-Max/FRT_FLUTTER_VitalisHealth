import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class ClimbingHabitSettingsScreen extends StatefulWidget {
  const ClimbingHabitSettingsScreen({super.key});

  @override
  State<ClimbingHabitSettingsScreen> createState() =>
      _ClimbingHabitSettingsScreenState();
}

class _ClimbingHabitSettingsScreenState extends State<ClimbingHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Escalada',
    heroSubtitle: 'Evolua com seguranca, tecnica e regularidade.',
    backgroundImageAsset:
        'lib/assets/images/habitsImages/montainClimbForHabits.png',
  );

  double _distanceKm = 5;
  final Set<int> _selectedDays = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    final goalMeters = controller.climbingGoalMeters;
    if (goalMeters != null && goalMeters > 0) {
      _distanceKm = (goalMeters / 1000).clamp(1, 42).toDouble();
    }
    _selectedDays.addAll(controller.climbingDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.climbingReminderMinutes ?? 1200);
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

    VitalisHabitsScope.of(context).setClimbingPlan(
      goalMeters: (_distanceKm * 1000).round(),
      daysOfWeek: _selectedDays,
      reminderMinutes: _minutesFromTime(_reminderTime),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          max: 42,
          divisions: 82,
          markers: const ['1 km', '21 km', '42 km'],
          onChanged: (value) => setState(() => _distanceKm = value),
          icon: Icons.terrain_outlined,
          helperText: 'Ajuste a sua meta de distancia para cada sessao de escalada.',
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que voce pretende escalar.',
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
      ],
    );
  }
}
