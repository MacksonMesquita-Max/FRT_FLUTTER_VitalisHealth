import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class MedicineTimeHabitSettingsScreen extends StatefulWidget {
  const MedicineTimeHabitSettingsScreen({super.key});

  @override
  State<MedicineTimeHabitSettingsScreen> createState() =>
      _MedicineTimeHabitSettingsScreenState();
}

class _MedicineTimeHabitSettingsScreenState
    extends State<MedicineTimeHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Hora do Remédio',
    heroSubtitle: 'Organize seus lembretes e mantenha a consistência do tratamento.',
    backgroundImageAsset:
        'lib/assets/images/habitsImages/MedicalReminderForHabits.png',
  );

  final _medicineController = TextEditingController();
  final Set<int> _selectedDays = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  String? _medicineError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _medicineController.text = controller.medicineName ?? '';
    _selectedDays.addAll(controller.medicineDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.medicineReminderMinutes ?? 480);
    _initialized = true;
  }

  @override
  void dispose() {
    _medicineController.dispose();
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
    final medicineName = _medicineController.text.trim();

    setState(() {
      _medicineError =
          medicineName.isEmpty ? 'Informe o nome do remedio.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_medicineError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setMedicinePlan(
      medicineName: medicineName,
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
        _QuestionCard(
          title: 'Qual remedio você deseja lembrar?',
          child: VitalisTextField(
            hintText: 'Ex: Vitamina D, Metformina...',
            controller: _medicineController,
            textInputAction: TextInputAction.done,
            errorText: _medicineError,
            suffixIcon: const Icon(
              Icons.medication_outlined,
              color: AppColors.outlineVariant,
            ),
          ),
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você deve tomar o remedio.',
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

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.title,
    required this.child,
  });

  final String title;
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
                  const Icon(Icons.medication_outlined,
                      color: AppColors.onSurface, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
