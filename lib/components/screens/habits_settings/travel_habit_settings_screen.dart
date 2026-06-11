import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_scaffold.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_reminder_time_field.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_weekday_selector_card.dart';

class TravelHabitSettingsScreen extends StatefulWidget {
  const TravelHabitSettingsScreen({super.key});

  @override
  State<TravelHabitSettingsScreen> createState() => _TravelHabitSettingsScreenState();
}

class _TravelHabitSettingsScreenState extends State<TravelHabitSettingsScreen> {
  static const _spec = VitalisHabitSettingsSpec(
    appBarTitle: 'Vitalis',
    heroTitle: 'Viagens',
    heroSubtitle: 'Organize seu destino, a contagem regressiva e a mala da viagem.',
    backgroundImageAsset: 'lib/assets/images/habitsImages/travelForHabits.png',
  );

  final _destinationController = TextEditingController();
  final _itemController = TextEditingController();
  final List<String> _packingItems = [];
  final Set<int> _selectedDays = {};
  DateTime? _travelDate;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String? _destinationError;
  String? _dateError;
  String? _daysError;
  String? _itemError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final controller = VitalisHabitsScope.of(context);
    _destinationController.text = controller.travelDestinationName ?? '';
    _travelDate = controller.travelDate;
    _packingItems.addAll(controller.travelPackingItems);
    _selectedDays.addAll(controller.travelDaysOfWeek);
    _reminderTime = _timeFromMinutes(controller.travelReminderMinutes ?? 540);
    _initialized = true;
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _itemController.dispose();
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _travelDate ?? now.add(const Duration(days: 7));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() {
        _travelDate = DateTime(picked.year, picked.month, picked.day);
        _dateError = null;
      });
    }
  }

  void _addPackingItem() {
    final item = _itemController.text.trim();
    setState(() {
      _itemError = item.isEmpty ? 'Digite um item antes de adicionar.' : null;
      if (_itemError != null) return;
      _packingItems.add(item);
      _itemController.clear();
    });
  }

  void _removePackingItem(String item) {
    setState(() {
      _packingItems.remove(item);
    });
  }

  int? _daysUntilTravel() {
    final travelDate = _travelDate;
    if (travelDate == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return travelDate.difference(today).inDays;
  }

  void _confirm() {
    final destinationName = _destinationController.text.trim();

    setState(() {
      _destinationError =
          destinationName.isEmpty ? 'Informe o destino da viagem.' : null;
      _dateError = _travelDate == null ? 'Selecione a data da viagem.' : null;
      _daysError = _selectedDays.isEmpty ? 'Selecione ao menos um dia.' : null;
    });

    if (_destinationError != null || _dateError != null || _daysError != null) {
      return;
    }

    VitalisHabitsScope.of(context).setTravelPlan(
      destinationName: destinationName,
      travelDate: _travelDate!,
      packingItems: _packingItems,
      daysOfWeek: _selectedDays,
      reminderMinutes: _minutesFromTime(_reminderTime),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final daysUntilTravel = _daysUntilTravel();

    return VitalisHabitSettingsScaffold(
      spec: _spec,
      onConfirm: _confirm,
      confirmTrailing: const Icon(Icons.check_circle_outline, size: 18),
      children: [
        Text(
          'DESTINO DA VIAGEM',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        VitalisTextField(
          hintText: 'Ex: Lisboa, Rio de Janeiro, Escócia...',
          controller: _destinationController,
          textInputAction: TextInputAction.next,
          errorText: _destinationError,
          suffixIcon: const Icon(
            Icons.place_outlined,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(height: 18),
        _TravelDateField(
          date: _travelDate,
          onTap: _pickDate,
          errorText: _dateError,
        ),
        const SizedBox(height: 18),
        if (daysUntilTravel != null)
          _TravelCountdownCard(daysUntilTravel: daysUntilTravel),
        if (daysUntilTravel != null) const SizedBox(height: 18),
        VitalisWeekdaySelectorCard(
          selectedDays: _selectedDays,
          onToggleDay: _toggleDay,
          helperText: 'Selecione os dias em que você quer revisar o planejamento da viagem.',
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
          helperText: 'Defina um horário para lembrar de revisar a viagem e a mala de viagem.',
          onChanged: (value) => setState(() => _reminderTime = value),
        ),
        const SizedBox(height: 18),
        Text(
          'Itens para levar',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: VitalisTextField(
                hintText: 'Ex: Passaporte, carregador, casaco...',
                controller: _itemController,
                textInputAction: TextInputAction.done,
                errorText: _itemError,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 58,
              child: FilledButton(
                onPressed: _addPackingItem,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _PackingListCard(
          items: _packingItems,
          onRemove: _removePackingItem,
        ),
      ],
    );
  }
}

class _TravelDateField extends StatelessWidget {
  const _TravelDateField({
    required this.date,
    required this.onTap,
    required this.errorText,
  });

  final DateTime? date;
  final VoidCallback onTap;
  final String? errorText;

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quando é a viagem?',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: errorText == null
                      ? Colors.transparent
                      : const Color(0xFFB3261E),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      date == null ? 'Selecionar data' : _formatDate(date!),
                      style: textTheme.bodyLarge?.copyWith(
                        color: date == null
                            ? AppColors.outline
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.outlineVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _TravelCountdownCard extends StatelessWidget {
  const _TravelCountdownCard({
    required this.daysUntilTravel,
  });

  final int daysUntilTravel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final label = switch (daysUntilTravel) {
      < 0 => 'A data escolhida já passou.',
      0 => 'Sua viagem e hoje!',
      1 => 'Falta 1 dia para a viagem.',
      _ => 'Faltam $daysUntilTravel dias para a viagem.',
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFEAF2FF)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.flight_takeoff_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackingListCard extends StatelessWidget {
  const _PackingListCard({
    required this.items,
    required this.onRemove,
  });

  final List<String> items;
  final ValueChanged<String> onRemove;

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
          child: items.isEmpty
              ? Text(
                  'Adicione os itens um por vez para organizar sua mala.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.outline,
                    height: 1.25,
                  ),
                )
              : Column(
                  children: items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => onRemove(item),
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.outlineVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}
