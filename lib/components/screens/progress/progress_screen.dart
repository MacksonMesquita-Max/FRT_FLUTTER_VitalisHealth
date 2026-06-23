import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/components/home/vitalis_user_avatar.dart';
import 'package:vitalis_app/components/components/progress/achievements/vitalis_recent_achievements_module.dart';
import 'package:vitalis_app/components/components/progress/achievements/vitalis_unlocked_achievement_banner.dart';
import 'package:vitalis_app/components/components/progress/vitalis_trending_habit_card.dart';
import 'package:vitalis_app/components/navigation/vitalis_bottom_nav_bar.dart';
import 'package:vitalis_app/components/screens/all_achievements_screen/all_achievements_screen.dart';
import 'package:vitalis_app/components/screens/profile/edit_profile_screen.dart';
import 'package:vitalis_app/components/screens/home/home_screen.dart';
import 'package:vitalis_app/components/screens/profile/profile_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Timer? _achievementBannerTimer;
  bool _showUnlockedAchievementBanner = true;

  static const _quoteText =
      '"Cada dia é um novo começo.\n'
      'Ontem foi para aprender,\n'
      'hoje é para crescer.\n'
      'Estamos orgulhosos de você!"';

  @override
  void initState() {
    super.initState();
    _achievementBannerTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _showUnlockedAchievementBanner = false);
    });
  }

  @override
  void dispose() {
    _achievementBannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Future<void> openHome() async {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }

    Future<void> openProfile() async {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
      );
    }

    Future<void> openEditProfile() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        ),
      );
    }

    Future<void> openAllAchievements() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AllachievementsScreen(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: VitalisBottomNavBar(
        isHomeSelected: false,
        isProgressSelected: true,
        onHomePressed: openHome,
        onProfilePressed: openProfile,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                18,
                _showUnlockedAchievementBanner ? 132 : 10,
                18,
                22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const VitalisUserAvatar(),
                          const SizedBox(width: 9),
                          Text(
                            'Vitalis',
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: openEditProfile,
                        icon: const Icon(Icons.settings_outlined),
                        color: AppColors.onSurface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Seu progresso',
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ProgressQuoteCard(
                    text: _quoteText,
                  ),
                  const SizedBox(height: 17),
                  const VitalisTrendingHabitCard(),
                  const SizedBox(height: 17),
                  VitalisRecentAchievementsModule(
                    onViewAllPressed: openAllAchievements,
                  ),
                ],
              ),
            ),
          ),
          if (_showUnlockedAchievementBanner)
            Positioned(
              top: 10,
              left: 18,
              right: 18,
              child: SafeArea(
                bottom: false,
                child: VitalisUnlockedAchievementBanner(
                  onPressed: openAllAchievements,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressQuoteCard extends StatelessWidget {
  const _ProgressQuoteCard({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFD7F1E8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.eco_rounded,
                color: AppColors.secondary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
