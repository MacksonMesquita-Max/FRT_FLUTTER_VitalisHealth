import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisTutorialBannerCard extends StatelessWidget {
  const VitalisTutorialBannerCard({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  static const _animationAsset =
      'lib/assets/animations/67d02376-c0a4-11ef-baa8-c3b21d24826c.json';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.surfaceContainer, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Se sentindo perdido nessa aventura?',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Clique aqui para ver o tutorial que preparamos para você!',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurface,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 92,
                  height: 92,
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
