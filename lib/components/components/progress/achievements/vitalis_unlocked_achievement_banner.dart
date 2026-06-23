import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisUnlockedAchievementBanner extends StatelessWidget {
  const VitalisUnlockedAchievementBanner({
    super.key,
    this.onPressed,
  });

  static const _animationAsset =
      'lib/assets/animations/Award or achievement animation.json';

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      elevation: 10,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.surfaceContainer, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Nova conquista desbloqueada',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Parabens, você desbloqueou uma nova conquista, clique aqui para ver',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurface,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 82,
                  height: 82,
                  child: Lottie.asset(
                    _animationAsset,
                    repeat: true,
                    fit: BoxFit.contain,
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
