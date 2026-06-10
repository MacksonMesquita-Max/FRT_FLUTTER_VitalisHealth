import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisReminderTimeField extends StatelessWidget {
  const VitalisReminderTimeField({
    super.key,
    required this.time,
    required this.onChanged,
    this.label = 'HORARIO DO LEMBRETE',
    this.helperText = 'Você recebera uma notificação no horário definido.',
    this.trailingIcon = Icons.notifications_none_outlined,
  });

  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;
  final String label;
  final String helperText;
  final IconData trailingIcon;

  String _formatTime(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selectedTime != null) {
      onChanged(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
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
            onTap: () => _selectTime(context),
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatTime(time),
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  _ReminderTrailingIcon(icon: trailingIcon),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          helperText,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.outlineVariant,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _ReminderTrailingIcon extends StatelessWidget {
  const _ReminderTrailingIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 22,
      color: AppColors.outlineVariant,
    );
  }
}
