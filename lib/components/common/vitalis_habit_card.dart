import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisHabitCard extends StatelessWidget {
  const VitalisHabitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressColor,
    required this.iconAsset,
    this.iconBackgroundColor = AppColors.surfaceContainerLow,
    this.iconSize = 20,
    this.topRightText,
    this.trailing,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final double progress;
  final Color progressColor;
  final String iconAsset;
  final Color iconBackgroundColor;
  final double iconSize;
  final String? topRightText;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isSvg = iconAsset.toLowerCase().endsWith('.svg');
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: (Theme.of(context).textTheme.titleSmall?.fontSize ?? 14) + 1,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.outline,
          height: 1.2,
          fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) + 1,
        );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainer, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Center(
                        child: isSvg
                            ? SvgPicture.asset(
                                iconAsset,
                                width: iconSize,
                                height: iconSize,
                                fit: BoxFit.contain,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Image.asset(
                                iconAsset,
                                width: iconSize,
                                height: iconSize,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (trailing != null) trailing!,
                  if (trailing == null && topRightText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        topRightText!,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: titleStyle),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              const SizedBox(height: 10),
              Text(subtitle, style: subtitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}
