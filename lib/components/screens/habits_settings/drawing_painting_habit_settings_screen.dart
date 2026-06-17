import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class DrawingPaintingHabitSettingsScreen extends StatefulWidget {
  const DrawingPaintingHabitSettingsScreen({super.key});

  @override
  State<DrawingPaintingHabitSettingsScreen> createState() =>
      _DrawingPaintingHabitSettingsScreenState();
}

class _DrawingPaintingHabitSettingsScreenState
    extends State<DrawingPaintingHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Desenho e Pintura',
    heroSubtitle:
        'Transforme criatividade em rotina com pratica constante e leveza.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/paintingForHabit.png',
  );

  final _techniqueController = TextEditingController();
  final Set<int> _selectedDays = {};
  double _durationMinutes = 20;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 10, minute: 0);
  String? _techniqueError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _techniqueController.text = controller.drawingPaintingTechnique ?? '';
    _durationMinutes = (controller.drawingPaintingDurationMinutes ?? 20)
        .clamp(5, 60)
        .toDouble();
    _selectedDays.addAll(controller.drawingPaintingDaysOfWeek);
    _reminderTime = _timeFromMinutes(
      controller.drawingPaintingReminderMinutes ?? 600,
    );
    _initialized = true;
  }

  @override
  void dispose() {
    _techniqueController.dispose();
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
    final technique = _techniqueController.text.trim();

    setState(() {
      _techniqueError =
          technique.isEmpty ? 'Informe a técnica que deseja praticar.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_techniqueError != null || _daysError != null) return;

    VitalisHabitsScope.of(context).setDrawingPaintingPlan(
      technique: technique,
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
        _QuestionCard(
          title: 'Qual técnica você quer praticar?',
          child: VitalisTextField(
            hintText: 'Ex: Aquarela, Desenho a Lápis, Giz Pastel...',
            controller: _techniqueController,
            textInputAction: TextInputAction.done,
            errorText: _techniqueError,
            suffixIcon: const Icon(
              Icons.search,
              color: AppColors.outlineVariant,
            ),
          ),
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
        const SizedBox(height: 18),
        const _BenefitsCard(
          title: 'Beneficios da Arte',
          description:
              'Praticar artes visuais estimula a neuroplasticidade, criando novas conexoes neurais. Alem disso, o foco na criação de artes promove estado de fluxo, reduzindo drasticamente os niveis de cortisol e estresse.',
          tags: ['#SaudeMental', '#Criatividade'],
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
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w900,
                ),
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

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard({
    required this.title,
    required this.description,
    required this.tags,
  });

  final String title;
  final String description;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF63F089),
              Color(0xFF5BE882),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    color: AppColors.secondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondary,
                  height: 1.32,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: tags
                    .map(
                      (tag) => Text(
                        tag,
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
