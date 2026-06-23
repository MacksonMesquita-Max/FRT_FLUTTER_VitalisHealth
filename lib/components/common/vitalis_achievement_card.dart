import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisAchievementCard extends StatelessWidget {
  const VitalisAchievementCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardOpacity = isUnlocked ? 1.0 : 0.58;

    return Opacity(
      opacity: cardOpacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.surfaceContainer, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isUnlocked ? const Color(0xFFD8F3E8) : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: isUnlocked ? AppColors.secondary : AppColors.outline,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ),
                          if (!isUnlocked) ...[
                            const SizedBox(width: 10),
                            Icon(
                              Icons.lock_rounded,
                              color: AppColors.outline,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.outline,
                          height: 1.28,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
