import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisAchievementsCard extends StatelessWidget {
  const VitalisAchievementsCard({super.key});

  static const _items = <_AchievementItem>[
    _AchievementItem(
      label: 'Hidratada',
      icon: Icons.water_drop,
      backgroundColor: Color(0xFFD8F3E8),
      iconColor: AppColors.secondary,
    ),
    _AchievementItem(
      label: 'Zen',
      icon: Icons.self_improvement,
      backgroundColor: Color(0xFFD8F3E8),
      iconColor: AppColors.secondary,
    ),
    _AchievementItem(
      label: 'Caminhada',
      icon: Icons.directions_walk_outlined,
      backgroundColor: Color(0xFFE6E6E6),
      iconColor: AppColors.outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Minhas Conquistas',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.secondary,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _items
                .map((item) => _AchievementBadge(item: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.item,
  });

  final _AchievementItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: item.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: item.iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementItem {
  const _AchievementItem({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
}
