import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/screens/all_achievements_screen/achievements_catalog/vitalis_achievements_catalog.dart';

class VitalisRecentAchievementsModule extends StatelessWidget {
  const VitalisRecentAchievementsModule({
    super.key,
    this.onViewAllPressed,
  });

  final VoidCallback? onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final unlockedAchievements = vitalisAchievementsCatalog.where((item) => item.isUnlocked).take(4).toList();

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF1F5C49),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conquistas Recentes',
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF8EC6B3),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              if (unlockedAchievements.isEmpty)
                const _EmptyAchievementsTile()
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: unlockedAchievements
                      .map(
                        (item) => _AchievementTile(
                          icon: item.icon,
                          label: item.title,
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 12),
              _ViewAllTile(onPressed: onViewAllPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = (MediaQuery.sizeOf(context).width - 18 - 18 - 16 - 16 - 12) / 2;

    return SizedBox(
      width: width,
      child: Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2F6E5A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF93CBB8),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF93CBB8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _EmptyAchievementsTile extends StatelessWidget {
  const _EmptyAchievementsTile();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2F6E5A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Nenhuma conquista desbloqueada ainda.',
        textAlign: TextAlign.center,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF93CBB8),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ViewAllTile extends StatelessWidget {
  const _ViewAllTile({
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF5F907E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.surfaceContainerLow.withValues(alpha: 0.7),
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                'Ver Todas',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.surfaceContainerLow.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
