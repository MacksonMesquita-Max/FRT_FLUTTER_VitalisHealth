import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisBackButton extends StatelessWidget {
  const VitalisBackButton({
    super.key,
    this.onPressed,
    this.foregroundColor = AppColors.onSurface,
    this.backgroundColor = const Color(0xE6FFFFFF),
  });

  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return IconButton(
      onPressed: onPressed ?? (canPop ? () => Navigator.of(context).maybePop() : null),
      icon: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.arrow_back,
            color: foregroundColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

