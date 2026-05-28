import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.outline,
        );

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text, style: textStyle),
        ),
        const Expanded(child: Divider(color: AppColors.outlineVariant)),
      ],
    );
  }
}

