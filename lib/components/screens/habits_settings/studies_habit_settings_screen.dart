import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class StudiesHabitSettingsScreen extends StatefulWidget {
  const StudiesHabitSettingsScreen({super.key});

  @override
  State<StudiesHabitSettingsScreen> createState() =>
      _StudiesHabitSettingsScreenState();
}

class _StudiesHabitSettingsScreenState extends State<StudiesHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Estudos',
    heroSubtitle: 'Construa foco e consistencia com pequenos passos todos os dias.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/studyForHabits.png',
  );

  final _subjectController = TextEditingController();
  final Set<int> _selectedDays = {};
  double _studyMinutes = 30;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 19, minute: 0);
  String? _subjectError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _subjectController.text = controller.studiesSubject ?? '';
    _studyMinutes = (controller.studiesStudyMinutes ?? 30).clamp(10, 180).toDouble();
    _selectedDays.addAll(controller.studiesDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.studiesReminderMinutes ?? 1140);
    _initialized = true;
  }

  @override
  void dispose() {
    _subjectController.dispose();
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
    final subject = _subjectController.text.trim();

    setState(() {
      _subjectError = subject.isEmpty ? 'Informe a materia.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_subjectError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setStudiesPlan(
      subject: subject,
      studyMinutes: _studyMinutes.round(),
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
          title: 'Qual materia você vai estudar?',
          child: VitalisTextField(
            hintText: 'Ex: Matematica, Ingles, Programacao...',
            controller: _subjectController,
            textInputAction: TextInputAction.done,
            errorText: _subjectError,
            suffixIcon: const Icon(
              Icons.school_outlined,
              color: AppColors.outlineVariant,
            ),
          ),
        ),
        const SizedBox(height: 18),
        VitalisSettingSliderCard(
          title: 'TEMPO DE ESTUDO',
          valueText: '${_studyMinutes.round()} min',
          value: _studyMinutes,
          min: 10,
          max: 180,
          divisions: 17,
          markers: const ['10 min', '60 min', '180 min'],
          onChanged: (value) => setState(() => _studyMinutes = value),
          icon: Icons.timer_outlined,
          helperText: 'Defina uma meta realista. A constancia vale mais do que a intensidade.',
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você pretende estudar.',
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
                  const Icon(Icons.school_outlined,
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
