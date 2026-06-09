import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class LanguagesHabitSettingsScreen extends StatefulWidget {
  const LanguagesHabitSettingsScreen({super.key});

  @override
  State<LanguagesHabitSettingsScreen> createState() =>
      _LanguagesHabitSettingsScreenState();
}

class _LanguagesHabitSettingsScreenState
    extends State<LanguagesHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Estudo de Idiomas',
    heroSubtitle: 'Aprenda com constancia e evolua um pouco todos os dias.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/languageForHabit.png',
  );

  final _languageController = TextEditingController();
  final Set<int> _selectedDays = {};
  double _studyMinutes = 15;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String? _languageError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _languageController.text = controller.languagesName ?? '';
    _studyMinutes = (controller.languagesStudyMinutes ?? 15)
        .clamp(5, 60)
        .toDouble();
    _selectedDays.addAll(controller.languagesDaysOfWeek);
    _reminderTime = _timeFromMinutes(
      controller.languagesReminderMinutes ?? 540,
    );
    _initialized = true;
  }

  @override
  void dispose() {
    _languageController.dispose();
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
    final languageName = _languageController.text.trim();

    setState(() {
      _languageError =
          languageName.isEmpty ? 'Informe o idioma que deseja estudar.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_languageError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setLanguagesPlan(
      languageName: languageName,
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
          title: 'Qual idioma voce quer aprender?',
          child: VitalisTextField(
            hintText: 'Ex: Ingles, Frances, Japones...',
            controller: _languageController,
            textInputAction: TextInputAction.done,
            errorText: _languageError,
            suffixIcon: const Icon(
              Icons.search,
              color: AppColors.outlineVariant,
            ),
          ),
        ),
        const SizedBox(height: 18),
        VitalisSettingSliderCard(
          title: 'META DIARIA DE ESTUDO',
          valueText: '${_studyMinutes.round()} min',
          value: _studyMinutes,
          min: 5,
          max: 60,
          divisions: 11,
          markers: const ['5 min', '30 min', '60 min'],
          onChanged: (value) => setState(() => _studyMinutes = value),
          icon: Icons.timer_outlined,
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que deseja praticar o idioma.',
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
        const _HighlightCard(
          backgroundColor: Color(0xFF73EE92),
          title: 'Por que aprender um idioma?',
          bullets: [
            'Melhora a neuroplasticidade e previne o declinio cognitivo.',
            'Aumenta a autoconfianca e abre novas portas culturais.',
          ],
        ),
        const SizedBox(height: 18),
        const _TipCard(
          title: 'DICA VITALIS',
          description:
              'Comece com apenas 15 minutos. A consistencia e mais poderosa do que a intensidade no aprendizado de idiomas.',
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
                  const Icon(Icons.language, color: AppColors.onSurface, size: 18),
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

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.backgroundColor,
    required this.title,
    required this.bullets,
  });

  final Color backgroundColor;
  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const icons = [
      Icons.lightbulb_outline,
      Icons.sentiment_satisfied_alt_outlined,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (var index = 0; index < bullets.length; index++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icons[index % icons.length],
                      size: 18,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bullets[index],
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondary,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
                if (index != bullets.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

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
              Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.outline,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
