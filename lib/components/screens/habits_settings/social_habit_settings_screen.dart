import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class SocialHabitSettingsScreen extends StatefulWidget {
  const SocialHabitSettingsScreen({super.key});

  @override
  State<SocialHabitSettingsScreen> createState() =>
      _SocialHabitSettingsScreenState();
}

class _SocialHabitSettingsScreenState extends State<SocialHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Habito Social',
    heroSubtitle: 'Planeje encontros importantes e mantenha sua vida social ativa.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/socialForHabits.png',
  );

  final _eventController = TextEditingController();
  final Set<int> _selectedDays = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _startTime = const TimeOfDay(hour: 20, minute: 0);
  String? _eventError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _eventController.text = controller.socialEventName ?? '';
    _selectedDays.addAll(controller.socialDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.socialReminderMinutes ?? 1080);
    _startTime = _timeFromMinutes(controller.socialStartMinutes ?? 1200);
    _initialized = true;
  }

  @override
  void dispose() {
    _eventController.dispose();
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
    final eventName = _eventController.text.trim();

    setState(() {
      _eventError = eventName.isEmpty ? 'Informe o nome do evento social.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_eventError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setSocialActivitiesPlan(
      eventName: eventName,
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
          'NOME DO EVENTO SOCIAL',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Jantar com amigos, Aniversario...',
          controller: _eventController,
          textInputAction: TextInputAction.done,
          errorText: _eventError,
          suffixIcon: const Icon(
            Icons.groups_outlined,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que esse compromisso costuma acontecer.',
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
          helperText: 'Defina o horario em que o evento social comeca.',
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
