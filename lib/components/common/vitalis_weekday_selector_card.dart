import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisWeekdaySelectorCard extends StatelessWidget {
  const VitalisWeekdaySelectorCard({
    super.key,
    required this.selectedDays,
    required this.onToggleDay,
    this.title = 'DIAS DA SEMANA',
    this.helperText,
  });

  final Set<int> selectedDays;
  final ValueChanged<int> onToggleDay;
  final String title;
  final String? helperText;

  static const List<_WeekdayItem> _days = [
    _WeekdayItem(label: 'D', value: 7),
    _WeekdayItem(label: 'S', value: 1),
    _WeekdayItem(label: 'T', value: 2),
    _WeekdayItem(label: 'Q', value: 3),
    _WeekdayItem(label: 'Q', value: 4),
    _WeekdayItem(label: 'S', value: 5),
    _WeekdayItem(label: 'S', value: 6),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.surfaceContainer, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _days
                        .map(
                          (day) => _WeekdayButton(
                            label: day.label,
                            selected: selectedDays.contains(day.value),
                            onTap: () => onToggleDay(day.value),
                          ),
                        )
                        .toList(),
                  ),
                  if (helperText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      helperText!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.outline,
                        height: 1.25,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeekdayButton extends StatelessWidget {
  const _WeekdayButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.surfaceContainer,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: selected ? Colors.white : AppColors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayItem {
  const _WeekdayItem({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;
}
