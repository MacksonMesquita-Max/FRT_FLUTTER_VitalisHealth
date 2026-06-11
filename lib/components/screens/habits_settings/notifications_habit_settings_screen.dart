import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_icon_picker_field.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_setting_slider_card.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class NotificationsHabitSettingsScreen extends StatefulWidget {
  const NotificationsHabitSettingsScreen({super.key});

  @override
  State<NotificationsHabitSettingsScreen> createState() =>
      _NotificationsHabitSettingsScreenState();
}

class _NotificationsHabitSettingsScreenState
    extends State<NotificationsHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Personalizar Notificações',
    heroSubtitle: 'Organize lembretes para reforçar o que importa na sua rotina.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/notificationForHabit.png',
  );

  static const List<VitalisIconPickerOption> _iconOptions = [
    VitalisIconPickerOption(key: 'bell', icon: Icons.notifications_none_outlined),
    VitalisIconPickerOption(key: 'calendar', icon: Icons.calendar_month_outlined),
    VitalisIconPickerOption(key: 'timer', icon: Icons.timer_outlined),
    VitalisIconPickerOption(key: 'mindfulness', icon: Icons.self_improvement),
    VitalisIconPickerOption(key: 'water', icon: Icons.water_drop_outlined),
    VitalisIconPickerOption(key: 'exercise', icon: Icons.fitness_center_outlined),
    VitalisIconPickerOption(key: 'sleep', icon: Icons.nightlight_round),
    VitalisIconPickerOption(key: 'food', icon: Icons.restaurant_outlined),
    VitalisIconPickerOption(key: 'reading', icon: Icons.menu_book_outlined),
    VitalisIconPickerOption(key: 'study', icon: Icons.lightbulb_outline),
    VitalisIconPickerOption(key: 'music', icon: Icons.music_note_outlined),
    VitalisIconPickerOption(key: 'med', icon: Icons.medication_outlined),
    VitalisIconPickerOption(key: 'walk', icon: Icons.directions_walk),
    VitalisIconPickerOption(key: 'heart', icon: Icons.favorite_border),
    VitalisIconPickerOption(key: 'sun', icon: Icons.wb_sunny_outlined),
    VitalisIconPickerOption(key: 'star', icon: Icons.star_border),
    VitalisIconPickerOption(key: 'phone', icon: Icons.phone_android_outlined),
    VitalisIconPickerOption(key: 'book', icon: Icons.auto_stories_outlined),
    VitalisIconPickerOption(key: 'check', icon: Icons.task_alt_outlined),
    VitalisIconPickerOption(key: 'home', icon: Icons.home_outlined),
    VitalisIconPickerOption(key: 'work', icon: Icons.work_outline),
    VitalisIconPickerOption(key: 'car', icon: Icons.directions_car_outlined),
    VitalisIconPickerOption(key: 'flight', icon: Icons.flight_takeoff_outlined),
    VitalisIconPickerOption(key: 'camera', icon: Icons.camera_alt_outlined),
    VitalisIconPickerOption(key: 'shopping', icon: Icons.shopping_bag_outlined),
    VitalisIconPickerOption(key: 'pet', icon: Icons.pets_outlined),
    VitalisIconPickerOption(key: 'coffee', icon: Icons.coffee_outlined),
    VitalisIconPickerOption(key: 'gift', icon: Icons.card_giftcard_outlined),
    VitalisIconPickerOption(key: 'brush', icon: Icons.brush_outlined),
    VitalisIconPickerOption(key: 'bike', icon: Icons.pedal_bike_outlined),
  ];

  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final Set<int> _selectedDays = {};
  double _goalMinutes = 20;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  String _selectedIconKey = 'bell';
  String? _titleError;
  String? _subjectError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _titleController.text = controller.extraNotificationsTitle ?? '';
    _subjectController.text = controller.extraNotificationsSubject ?? '';
    _goalMinutes = (controller.extraNotificationsDurationMinutes ?? 20)
        .clamp(5, 60)
        .toDouble();
    _selectedDays.addAll(controller.extraNotificationsDaysOfWeek);
    _reminderTime = _timeFromMinutes(
      controller.extraNotificationsReminderMinutes ?? 480,
    );
    _selectedIconKey = controller.extraNotificationsIconKey ?? 'bell';
    _initialized = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
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
    final title = _titleController.text.trim();
    final subject = _subjectController.text.trim();

    setState(() {
      _titleError = title.isEmpty ? 'Informe o titulo do habito.' : null;
      _subjectError = subject.isEmpty ? 'Informe o assunto do habito.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_titleError != null || _subjectError != null || _daysError != null) {
      return;
    }

    VitalisHabitsScope.of(context).setExtraNotificationsPlan(
      title: title,
      durationMinutes: _goalMinutes.round(),
      daysOfWeek: _selectedDays,
      reminderMinutes: _minutesFromTime(_reminderTime),
      subject: subject,
      iconKey: _selectedIconKey,
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
          'Titulo do Hábito',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Meditação Matinal',
          controller: _titleController,
          textInputAction: TextInputAction.next,
          errorText: _titleError,
        ),
        const SizedBox(height: 18),
        VitalisSettingSliderCard(
          title: 'Meta a ser atingida',
          valueText: '${_goalMinutes.round()} min',
          value: _goalMinutes,
          min: 5,
          max: 60,
          divisions: 11,
          markers: const ['5 min', '30 min', '60 min'],
          onChanged: (value) => setState(() => _goalMinutes = value),
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
        Text(
          'Assunto do Hábito',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Respiração e Foco',
          controller: _subjectController,
          textInputAction: TextInputAction.done,
          errorText: _subjectError,
        ),
        const SizedBox(height: 18),
        VitalisIconPickerField(
          label: 'Escolher ícone',
          options: _iconOptions,
          selectedKey: _selectedIconKey,
          onChanged: (value) => setState(() => _selectedIconKey = value),
        ),
      ],
    );
  }
}
