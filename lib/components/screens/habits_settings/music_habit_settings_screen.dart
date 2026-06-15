import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class MusicHabitSettingsScreen extends StatefulWidget {
  const MusicHabitSettingsScreen({super.key});

  @override
  State<MusicHabitSettingsScreen> createState() => _MusicHabitSettingsScreenState();
}

class _MusicHabitSettingsScreenState extends State<MusicHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Musica',
    heroSubtitle: 'Treine um pouco por dia e perceba a evolucao semana a semana.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/musicForHabits.png',
  );

  final Set<int> _selectedDays = {};
  double _practiceMinutes = 20;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 30);
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _practiceMinutes = (controller.musicStudyMinutes ?? 20).clamp(10, 180).toDouble();
    _selectedDays.addAll(controller.musicDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.musicReminderMinutes ?? 1110);
    _initialized = true;
  }

  TimeOfDay _timeFromMinutes(int totalMinutes) {
    final normalized = totalMinutes.clamp(0, 1439);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  int _minutesFromTime(TimeOfDay time) => (time.hour * 60) + time.minute;

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

    VitalisHabitsScope.of(context).setMusicPlan(
      studyMinutes: _practiceMinutes.round(),
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
          title: 'Tempo de pratica',
          valueText: '${_practiceMinutes.round()} min',
          value: _practiceMinutes,
          min: 10,
          max: 180,
          divisions: 17,
          markers: const ['10 min', '60 min', '180 min'],
          onChanged: (value) => setState(() => _practiceMinutes = value),
          icon: Icons.music_note_outlined,
          helperText: 'Defina o tempo de pratica diario para manter o ritmo.',
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você quer praticar musica.',
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
