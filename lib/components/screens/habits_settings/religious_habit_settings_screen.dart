import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class ReligiousHabitSettingsScreen extends StatefulWidget {
  const ReligiousHabitSettingsScreen({super.key});

  @override
  State<ReligiousHabitSettingsScreen> createState() =>
      _ReligiousHabitSettingsScreenState();
}

class _ReligiousHabitSettingsScreenState
    extends State<ReligiousHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Hábito Religioso',
    heroSubtitle: 'Cultivando a fe e a paz interior.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/religionForHabit.png',
    imageAlignment: Alignment.topCenter,
  );

  final _practiceController = TextEditingController();
  final Set<int> _selectedDays = {};
  double _durationMinutes = 15;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 7, minute: 0);
  String? _practiceError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _practiceController.text = controller.religiousPracticeName ?? '';
    _durationMinutes = (controller.religiousDurationMinutes ?? 15)
        .clamp(5, 60)
        .toDouble();
    _selectedDays.addAll(controller.religiousDaysOfWeek);
    _reminderTime = _timeFromMinutes(
      controller.religiousReminderMinutes ?? 420,
    );
    _initialized = true;
  }

  @override
  void dispose() {
    _practiceController.dispose();
    super.dispose();
  }

  TimeOfDay _timeFromMinutes(int totalMinutes) {
    final normalized = totalMinutes.clamp(0, 1439);
    return TimeOfDay(
      hour: normalized ~/ 60,
      minute: normalized % 60,
    );
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

  Future<void> _confirm() async {
    final practiceName = _practiceController.text.trim();

    setState(() {
      _practiceError =
          practiceName.isEmpty ? 'Informe o nome da pratica.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_practiceError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setReligiousPlan(
      practiceName: practiceName,
      durationMinutes: _durationMinutes.round(),
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
        Text(
          'Nome da Prática',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Oração, Estudo Biblico, Rezo',
          controller: _practiceController,
          textInputAction: TextInputAction.done,
          errorText: _practiceError,
        ),
        const SizedBox(height: 18),
        VitalisSettingSliderCard(
          title: 'Tempo de dedicação',
          valueText: '${_durationMinutes.round()} min',
          value: _durationMinutes,
          min: 5,
          max: 60,
          divisions: 11,
          markers: const ['5 min', '30 min', '60 min'],
          onChanged: (value) => setState(() => _durationMinutes = value),
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
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
