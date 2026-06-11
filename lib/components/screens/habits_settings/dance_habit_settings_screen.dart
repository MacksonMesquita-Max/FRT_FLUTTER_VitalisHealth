import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class DanceHabitSettingsScreen extends StatefulWidget {
  const DanceHabitSettingsScreen({super.key});

  @override
  State<DanceHabitSettingsScreen> createState() => _DanceHabitSettingsScreenState();
}

class _DanceHabitSettingsScreenState extends State<DanceHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Dança',
    heroSubtitle: 'Escolha seu estilo e mantenha consistência nos treinos.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/danceForHabits.png',
  );

  final _danceController = TextEditingController();
  final Set<int> _selectedDays = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay _startTime = const TimeOfDay(hour: 19, minute: 0);
  String? _danceError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _danceController.text = controller.danceStyleName ?? '';
    _selectedDays.addAll(controller.danceDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.danceReminderMinutes ?? 1020);
    _startTime = _timeFromMinutes(controller.danceStartMinutes ?? 1140);
    _initialized = true;
  }

  @override
  void dispose() {
    _danceController.dispose();
    super.dispose();
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
    final danceStyleName = _danceController.text.trim();

    setState(() {
      _danceError = danceStyleName.isEmpty ? 'Informe o nome da dança.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_danceError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setDancePlan(
      danceStyleName: danceStyleName,
      daysOfWeek: _selectedDays,
      startMinutes: _minutesFromTime(_startTime),
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
        Text(
          'Nome da dança',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Forro, Ballet, Hip Hop...',
          controller: _danceController,
          textInputAction: TextInputAction.done,
          errorText: _danceError,
          suffixIcon: const Icon(
            Icons.music_note_outlined,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você vai praticar a dança.',
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
          time: _startTime,
          label: 'HORARIO DE INICIO',
          helperText: 'Defina o horario em que o treino ou aula comeca.',
          trailingIcon: Icons.schedule_outlined,
          onChanged: (value) => setState(() => _startTime = value),
        ),
        const SizedBox(height: 18),
        VitalisReminderTimeField(
          time: _reminderTime,
          onChanged: (value) => setState(() => _reminderTime = value),
        ),
      ],
    );
  }
}
