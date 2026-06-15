import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/home/vitalis_bottom_nav_bar.dart';
import 'package:vitalis_app/components/components/home/vitalis_user_avatar.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';
import 'package:vitalis_app/components/screens/profile/edit_profile_screen.dart';
import 'package:vitalis_app/components/screens/home/home_screen.dart';
import 'package:vitalis_app/components/screens/premium/vitalis_premium_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _formatMemberSince(DateTime date) {
    const months = <int, String>{
      1: 'Janeiro',
      2: 'Fevereiro',
      3: 'Marco',
      4: 'Abril',
      5: 'Maio',
      6: 'Junho',
      7: 'Julho',
      8: 'Agosto',
      9: 'Setembro',
      10: 'Outubro',
      11: 'Novembro',
      12: 'Dezembro',
    };

    return '${date.day} de ${months[date.month] ?? 'Janeiro'} de ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileController = VitalisUserProfileScope.of(context);
    final userName = profileController.displayName;
    final memberSince = profileController.memberSince;
    final userId = profileController.userId;

    Future<void> openHome() async {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }

    Future<void> openPremium() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VitalisPremiumScreen(),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: VitalisBottomNavBar(
        isHomeSelected: false,
        isProfileSelected: true,
        onHomePressed: openHome,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VitalisUserAvatar(),
                      SizedBox(width: 10),
                      Text(
                        'Vitalis',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 42),
              const Center(
                child: VitalisUserAvatar(size: 72),
              ),
              const SizedBox(height: 20),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Membro desde ${_formatMemberSince(memberSince)}',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'userID: $userId',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 180,
                  child: VitalisPrimaryButton(
                    label: 'Editar Perfil',
                    onPressed: openEditProfile,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _PremiumUpgradeCard(onPressed: openPremium),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumUpgradeCard extends StatelessWidget {
  const _PremiumUpgradeCard({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mudar para\nPremium',
                  style: textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF7FF1C8),
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Desbloqueie\nmeditacoes guiadas e\nanalises detalhadas.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFA9D8C8),
                    height: 1.28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFA6F2D7),
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('Ver Planos'),
                ),
              ],
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.stars_rounded,
              size: 64,
              color: const Color(0xFF7FF1C8).withValues(alpha: 0.22),
            ),
          ),
        ],
      ),
    );
  }
}
