import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisPrimaryButton extends StatelessWidget {
  const VitalisPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(58),
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

