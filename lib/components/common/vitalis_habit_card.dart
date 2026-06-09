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
    this.iconAsset,
    this.iconData,
    this.iconBackgroundColor = AppColors.surfaceContainerLow,
    this.iconSize = 20,
    this.topRightText,
    this.trailing,
    this.onPressed,
  }) : assert(iconAsset != null || iconData != null);

  final String title;
  final String subtitle;
  final double progress;
  final Color progressColor;
  final String? iconAsset;
  final IconData? iconData;
  final Color iconBackgroundColor;
  final double iconSize;
  final String? topRightText;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final asset = iconAsset;
    final isSvg = asset?.toLowerCase().endsWith('.svg') ?? false;
    final iconLower = asset?.toLowerCase() ?? '';
    final applySvgColorFilter = !(iconLower.endsWith('medicine.svg') ||
        iconLower.endsWith('reading.svg'));
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: Theme.of(context).textTheme.titleSmall?.fontSize ?? 13,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.outline,
          height: 1.2,
          fontSize: Theme.of(context).textTheme.bodySmall?.fontSize ?? 11,
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
                        child: iconData != null
                            ? Icon(
                                iconData,
                                size: iconSize,
                                color: AppColors.primary,
                              )
                            : isSvg
                                ? SvgPicture.asset(
                                    asset!,
                                    width: iconSize,
                                    height: iconSize,
                                    fit: BoxFit.contain,
                                    colorFilter: applySvgColorFilter
                                        ? const ColorFilter.mode(
                                            AppColors.primary,
                                            BlendMode.srcIn,
                                          )
                                        : null,
                                  )
                                : Image.asset(
                                    asset!,
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
              Text(
                title,
                style: titleStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
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
              Text(
                subtitle,
                style: subtitleStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
