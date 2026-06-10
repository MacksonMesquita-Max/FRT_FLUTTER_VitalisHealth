import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisSettingSliderCard extends StatelessWidget {
  const VitalisSettingSliderCard({
    super.key,
    required this.title,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.markers,
    this.icon,
    this.divisions,
    this.helperText,
  });

  final String title;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final List<String> markers;
  final IconData? icon;
  final String? helperText;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.secondary, size: 18),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    valueText,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.secondary,
                  inactiveTrackColor: AppColors.surfaceContainer,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.secondary.withValues(alpha: 0.12),
                  trackHeight: 3.5,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: markers
                    .map(
                      (marker) => Text(
                        marker,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.outline,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (helperText != null) ...[
                const SizedBox(height: 10),
                Text(
                  helperText!,
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
    );
  }
}
