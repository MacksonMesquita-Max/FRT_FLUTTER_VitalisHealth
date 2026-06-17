import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

enum VitalisHabitSheetAction {
  viewDetails,
  delete,
}

class VitalisHabitActionsSheet extends StatelessWidget {
  const VitalisHabitActionsSheet({
    super.key,
    required this.habitTitle,
  });

  final String habitTitle;

  static Future<VitalisHabitSheetAction?> show(
    BuildContext context, {
    required String habitTitle,
  }) {
    return showModalBottomSheet<VitalisHabitSheetAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => VitalisHabitActionsSheet(habitTitle: habitTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              habitTitle,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Escolha o que deseja fazer com este hábito.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.outline,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 20),
            _SheetActionButton(
              label: 'Ver detalhes',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.onSurface,
              borderColor: AppColors.surfaceContainer,
              onPressed: () {
                Navigator.of(context).pop(VitalisHabitSheetAction.viewDetails);
              },
            ),
            const SizedBox(height: 12),
            _SheetActionButton(
              label: 'Excluir hábito',
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop(VitalisHabitSheetAction.delete);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        child: Text(label),
      ),
    );
  }
}
