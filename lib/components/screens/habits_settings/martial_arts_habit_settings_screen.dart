import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_martial_art_picker_field.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class MartialArtsHabitSettingsScreen extends StatefulWidget {
  const MartialArtsHabitSettingsScreen({super.key});

  @override
  State<MartialArtsHabitSettingsScreen> createState() =>
      _MartialArtsHabitSettingsScreenState();
}

class _MartialArtsHabitSettingsScreenState
    extends State<MartialArtsHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Artes Marciais',
    heroSubtitle: 'Escolha sua modalidade e mantenha disciplina nos treinos.',
    backgroundImageAsset:
        'lib/assets/images/habitsImages/marcialArtsForHabits.png',
  );

  static const List<VitalisMartialArtOption> _options = [
    VitalisMartialArtOption(
      key: 'boxe',
      label: 'Boxe',
      icon: Icons.sports_mma_outlined,
    ),
    VitalisMartialArtOption(
      key: 'jiujitsu',
      label: 'Jiujitsu',
      icon: Icons.sports_kabaddi_outlined,
    ),
    VitalisMartialArtOption(
      key: 'muay_thai',
      label: 'Muay Thai',
      icon: Icons.flash_on_outlined,
    ),
    VitalisMartialArtOption(
      key: 'karate',
      label: 'Karate',
      icon: Icons.back_hand_outlined,
    ),
    VitalisMartialArtOption(
      key: 'judo',
      label: 'Judo',
      icon: Icons.sports_outlined,
    ),
    VitalisMartialArtOption(
      key: 'taekwondo',
      label: 'Taekwondo',
      icon: Icons.bolt_outlined,
    ),
  ];

  final Set<int> _selectedDays = {};
  String? _selectedMartialArtKey;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay _startTime = const TimeOfDay(hour: 19, minute: 0);
  String? _martialArtError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    final savedName = controller.martialArtName;
    if (savedName != null) {
      for (final option in _options) {
        if (option.label.toLowerCase() == savedName.toLowerCase()) {
          _selectedMartialArtKey = option.key;
          break;
        }
      }
    }
    _selectedDays.addAll(controller.martialArtsDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.martialArtsReminderMinutes ?? 1020);
    _startTime = _timeFromMinutes(controller.martialArtsStartMinutes ?? 1140);
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
    final option = _options.where((item) => item.key == _selectedMartialArtKey).firstOrNull;

    setState(() {
      _martialArtError =
          option == null ? 'Selecione uma arte marcial.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_martialArtError != null || _daysError != null || option == null) return;

    VitalisHabitsScope.of(context).setMartialArtsPlan(
      martialArtName: option.label,
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
        VitalisMartialArtPickerField(
          label: 'ARTE MARCIAL',
          options: _options,
          selectedKey: _selectedMartialArtKey,
          onChanged: (value) => setState(() {
            _selectedMartialArtKey = value;
            _martialArtError = null;
          }),
        ),
        if (_martialArtError != null) ...[
          const SizedBox(height: 8),
          Text(
            _martialArtError!,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você quer treinar sua modalidade.',
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
          label: 'Horário de início',
          helperText: 'Defina o horário em que a aula ou treino começa.',
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
