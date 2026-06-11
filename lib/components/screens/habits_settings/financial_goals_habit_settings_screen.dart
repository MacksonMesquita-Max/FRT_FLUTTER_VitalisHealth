import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class FinancialGoalsHabitSettingsScreen extends StatefulWidget {
  const FinancialGoalsHabitSettingsScreen({super.key});

  @override
  State<FinancialGoalsHabitSettingsScreen> createState() =>
      _FinancialGoalsHabitSettingsScreenState();
}

class _FinancialGoalsHabitSettingsScreenState
    extends State<FinancialGoalsHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Financas',
    heroSubtitle: 'Transforme seu planejamento em uma meta clara e constante.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/financeForhabits.png',
  );

  final _purposeController = TextEditingController();
  final _savedController = TextEditingController();
  final _targetController = TextEditingController();
  final Set<int> _selectedDays = {};
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String? _purposeError;
  String? _savedError;
  String? _targetError;
  String? _daysError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _purposeController.text = controller.financialPurposeName ?? '';
    _savedController.text = controller.financialSavedAmount?.toString() ?? '';
    _targetController.text = controller.financialTargetAmount?.toString() ?? '';
    _selectedDays.addAll(controller.financialDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.financialReminderMinutes ?? 540);
    _initialized = true;
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _savedController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  TimeOfDay _timeFromMinutes(int totalMinutes) {
    final normalized = totalMinutes.clamp(0, 1439);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  int _minutesFromTime(TimeOfDay time) => (time.hour * 60) + time.minute;

  int? _parseAmount(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return null;
    return int.tryParse(digitsOnly);
  }

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
    final purposeName = _purposeController.text.trim();
    final savedAmount = _parseAmount(_savedController.text);
    final targetAmount = _parseAmount(_targetController.text);

    setState(() {
      _purposeError = purposeName.isEmpty ? 'Informe o objetivo financeiro.' : null;
      _savedError = savedAmount == null ? 'Informe quanto você ja guardou.' : null;
      _targetError = targetAmount == null
          ? 'Informe quanto você quer alcancar.'
          : targetAmount <= 0
              ? 'A meta precisa ser maior que zero.'
              : savedAmount != null && targetAmount < savedAmount
                  ? 'A meta final nao pode ser menor que o valor atual.'
                  : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_purposeError != null ||
        _savedError != null ||
        _targetError != null ||
        _daysError != null ||
        savedAmount == null ||
        targetAmount == null) {
      return;
    }

    VitalisHabitsScope.of(context).setFinancialGoalsPlan(
      purposeName: purposeName,
      savedAmount: savedAmount,
      targetAmount: targetAmount,
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
          'PROPÓSITO DA META',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Viagem, Reserva, Curso...',
          controller: _purposeController,
          textInputAction: TextInputAction.next,
          errorText: _purposeError,
          suffixIcon: const Icon(
            Icons.flag_outlined,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Quantanto você tem agora?',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: 1500',
          controller: _savedController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          errorText: _savedError,
          suffixIcon: const Icon(
            Icons.savings_outlined,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Quantanto você quer chegar a?',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: 10000',
          controller: _targetController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          errorText: _targetError,
          suffixIcon: const Icon(
            Icons.trending_up_outlined,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você quer revisar ou fortalecer essa meta.',
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
          helperText: 'Defina quando você quer ser lembrado de acompanhar sua meta.',
          onChanged: (value) => setState(() => _reminderTime = value),
        ),
      ],
    );
  }
}
