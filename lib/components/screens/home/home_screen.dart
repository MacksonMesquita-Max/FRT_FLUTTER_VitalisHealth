import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/habits/vitalis_habits_catalog.dart';
import 'package:vitalis_app/components/components/home/premuimCardsContent/vitalis_book_recommendations_card.dart';
import 'package:vitalis_app/components/components/home/premuimCardsContent/vitalis_psychology_support_card.dart';
import 'package:vitalis_app/components/components/home/premuimCardsContent/vitalis_meditation_card.dart';
import 'package:vitalis_app/components/components/home/premuimCardsContent/vitalis_friends_connection_card.dart';
import 'package:vitalis_app/components/components/home/vitalis_bottom_nav_bar.dart';
import 'package:vitalis_app/components/components/home/vitalis_habit_card.dart';
import 'package:vitalis_app/components/components/home/vitalis_motivation_carousel.dart';
import 'package:vitalis_app/components/components/home/vitalis_motivation_quotes.dart';
import 'package:vitalis_app/components/components/home/vitalis_tutorial_banner_card.dart';
import 'package:vitalis_app/components/components/home/vitalis_user_avatar.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_habit_actions_sheet.dart';
import 'package:vitalis_app/components/common/vitalis_habit_settings_routes.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';
import 'package:vitalis_app/components/screens/habits/select_habits_screen.dart';
import 'package:vitalis_app/components/screens/profile/edit_profile_screen.dart';
import 'package:vitalis_app/components/screens/profile/profile_screen.dart';
import 'package:vitalis_app/components/screens/premium/vitalis_premium_screen.dart';
import 'package:vitalis_app/components/utils/mood_formatter.dart';
import 'package:vitalis_app/components/utils/vitalis_formatters.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedHabits = VitalisHabitsScope.of(context).habits;
    final habitsController = VitalisHabitsScope.of(context);
    final profileController = VitalisUserProfileScope.of(context);
    final userName = profileController.displayName;
    final selectedDefinitions = VitalisHabitsCatalog.definitions.where((d) => selectedHabits.contains(d.habit)).toList();

    void openPremium() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VitalisPremiumScreen(),
        ),
      );
    }

    void openTutorial() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutorial em breve.')),
      );
    }

    Future<void> openSelectHabits() async {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const SelectHabitsScreen()),
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

    Future<void> handleHabitCardPressed(VitalisHabit habit, String title) async {
      final action = await VitalisHabitActionsSheet.show(
        context,
        habitTitle: title,
      );
      if (!context.mounted || action == null) return;

      switch (action) {
        case VitalisHabitSheetAction.viewDetails:
          await Navigator.of(context).push<bool>(
            createVitalisHabitSettingsRoute(habit),
          );
          return;
        case VitalisHabitSheetAction.delete:
          habitsController.remove(habit);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hábito excluido com sucesso'),
              behavior: SnackBarBehavior.fixed,
              backgroundColor: AppColors.secondary,
            ),
          );
          return;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
        shape: const CircleBorder(),
        onPressed: openSelectHabits,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: VitalisBottomNavBar(
        onProfilePressed: openProfile,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
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
              const SizedBox(height: 10),
              Text(
                'Olá, $userName',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Como está se sentindo hoje?\nReserve um momento para você.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.outline,
                  height: 1.25,
                  fontSize: (textTheme.bodyMedium?.fontSize ?? 14) + 1,
                ),
              ),
              const SizedBox(height: 16),
              VitalisTutorialBannerCard(onPressed: openTutorial),
              const SizedBox(height: 16),
              const VitalisMotivationCarousel(quotes: vitalisMotivationQuotes),
              const SizedBox(height: 16),
              const _DailyProgressCard(progressPercent: 0.72),
              const SizedBox(height: 16),
              if (selectedHabits.isEmpty)
                _NoHabitsCard(onAddPressed: openSelectHabits)
              else
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.13,
                  ),
                  itemCount: selectedDefinitions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final d = selectedDefinitions[index];

                    final dynamicSubtitle = switch (d.habit) {
                      VitalisHabit.hydration => () {
                          final goal = habitsController.hydrationGoalMl;
                          final consumed = habitsController.hydrationConsumedMl;
                          if (goal == null || goal <= 0) return 'Defina sua meta diária';
                          final remaining = (goal - consumed).clamp(0, goal);
                          return 'Bebeu ${formatLiters(consumed)}L • Faltam ${formatLiters(remaining)}L';
                        }(),
                      VitalisHabit.sleep => () {
                          final goal = habitsController.sleepGoalMinutes;
                          final slept = habitsController.sleepMinutes;
                          if (goal == null || goal <= 0) return 'Defina sua meta diária';
                          final remaining = (goal - slept).clamp(0, goal);
                          return 'Dormiu ${formatHours(slept)}h • Faltam ${formatHours(remaining)}h';
                        }(),
                      VitalisHabit.movement => () {
                          final goal = habitsController.movementGoalMeters;
                          final moved = habitsController.movementMeters;
                          if (goal == null || goal <= 0) return 'Defina sua meta de distância';
                          final remaining = (goal - moved).clamp(0, goal);
                          final line1 = 'Fez ${formatKm(moved)}km • Faltam ${formatKm(remaining)}km';
                          final days = formatDaysOfWeek(habitsController.movementDaysOfWeek);
                          return days.isEmpty ? line1 : '$line1\n$days';
                        }(),
                      VitalisHabit.swimming => () {
                          final goal = habitsController.swimmingGoalMeters;
                          final moved = habitsController.swimmingMeters;
                          if (goal == null || goal <= 0) return 'Defina sua meta de distância';
                          final remaining = (goal - moved).clamp(0, goal);
                          final line1 = 'Nadou ${formatKm(moved)}km • Faltam ${formatKm(remaining)}km';
                          final days = formatDaysOfWeek(habitsController.swimmingDaysOfWeek);
                          return days.isEmpty ? line1 : '$line1\n$days';
                        }(),
                      VitalisHabit.reading => () {
                          final book = habitsController.readingBookName;
                          final pages = habitsController.readingPageGoal;
                          if (book == null || pages == null) return 'Defina seu livro e sua meta';
                          final days = formatDaysOfWeek(habitsController.readingDaysOfWeek);
                          final line1 = book;
                          final line2 = 'Meta: $pages pág./dia';
                          if (days.isEmpty) return '$line1\n$line2';
                          return '$line1\n$days';
                        }(),
                      VitalisHabit.fasting => () {
                          final purpose = habitsController.fastingPurpose;
                          final hours = habitsController.fastingDurationHours;
                          if (purpose == null || hours == null) return 'Defina seu propósito e duração';
                          return '$purpose\nMeta: ${hours}h de jejum';
                        }(),
                      VitalisHabit.mood => () {
                          final last = habitsController.moodLastWeekLevel;
                          final target = habitsController.moodTargetLevel;
                          if (last == null || target == null) return 'Defina seu humor e sua meta';
                          return 'Última: ${moodLabel(last)} • Meta: ${moodLabel(target)}';
                        }(),
                      VitalisHabit.gym => () {
                          final duration = habitsController.gymDurationMinutes;
                          final intensity = habitsController.gymIntensity;
                          final focus = habitsController.gymFocus;
                          if (duration == null || intensity == null || focus == null) {
                            return 'Defina seu treino na academia';
                          }
                          final focusLabel = switch (focus) {
                            VitalisGymFocus.forca => 'Força',
                            VitalisGymFocus.cardio => 'Cardio',
                            VitalisGymFocus.flexibilidade => 'Flexibilidade',
                          };
                          final intensityLabel = switch (intensity) {
                            VitalisGymIntensity.leve => 'Leve',
                            VitalisGymIntensity.moderada => 'Moderada',
                            VitalisGymIntensity.intensa => 'Intensa',
                          };
                          final line1 = '$focusLabel • $intensityLabel';
                          final days = formatDaysOfWeek(habitsController.gymDaysOfWeek);
                          return days.isEmpty ? line1 : '$line1\n$days';
                        }(),
                      VitalisHabit.socialActivities => () {
                          final eventName = habitsController.socialEventName;
                          if (eventName == null || eventName.isEmpty) {
                            return 'Defina seu evento social';
                          }
                          final days = formatDaysOfWeek(habitsController.socialDaysOfWeek);
                          return days.isEmpty ? eventName : '$eventName\n$days';
                        }(),
                      VitalisHabit.martialArts => () {
                          final martialArtName = habitsController.martialArtName;
                          if (martialArtName == null || martialArtName.isEmpty) {
                            return 'Defina sua arte marcial';
                          }
                          final days = formatDaysOfWeek(
                            habitsController.martialArtsDaysOfWeek,
                          );
                          return days.isEmpty
                              ? martialArtName
                              : '$martialArtName\n$days';
                        }(),
                      VitalisHabit.dance => () {
                          final danceStyleName = habitsController.danceStyleName;
                          if (danceStyleName == null || danceStyleName.isEmpty) {
                            return 'Defina sua danca';
                          }
                          final days = formatDaysOfWeek(habitsController.danceDaysOfWeek);
                          return days.isEmpty ? danceStyleName : '$danceStyleName\n$days';
                        }(),
                      VitalisHabit.financialGoals => () {
                          final purposeName = habitsController.financialPurposeName;
                          final saved = habitsController.financialSavedAmount;
                          final target = habitsController.financialTargetAmount;
                          if (purposeName == null || saved == null || target == null) {
                            return 'Defina seu objetivo financeiro';
                          }
                          return '$purposeName\n${formatMoney(saved)} de ${formatMoney(target)}';
                        }(),
                      VitalisHabit.travel => () {
                          final destination = habitsController.travelDestinationName;
                          final travelDate = habitsController.travelDate;
                          if (destination == null || travelDate == null) {
                            return 'Defina seu destino e a data da viagem';
                          }
                          return '$destination\n${formatDate(travelDate)}';
                        }(),
                      VitalisHabit.cycling => () {
                          final goal = habitsController.cyclingGoalMeters;
                          if (goal == null || goal <= 0) {
                            return 'Defina sua meta de distancia';
                          }
                          final days = formatDaysOfWeek(habitsController.cyclingDaysOfWeek);
                          final line1 = 'Meta: ${formatKm(goal)}km por sessao';
                          return days.isEmpty ? line1 : '$line1\n$days';
                        }(),
                      _ => d.subtitle ?? '50% concluído',
                    };

                    final dynamicTopRightText = switch (d.habit) {
                      VitalisHabit.hydration => () {
                          final goal = habitsController.hydrationGoalMl;
                          final consumed = habitsController.hydrationConsumedMl;
                          if (goal == null || goal <= 0) return '—';
                          return '${formatLiters(consumed)} / ${formatLiters(goal)}L';
                        }(),
                      VitalisHabit.sleep => () {
                          final goal = habitsController.sleepGoalMinutes;
                          final slept = habitsController.sleepMinutes;
                          if (goal == null || goal <= 0) return '—';
                          return '${formatHours(slept)} / ${formatHours(goal)}h';
                        }(),
                      VitalisHabit.movement => () {
                          final goal = habitsController.movementGoalMeters;
                          final moved = habitsController.movementMeters;
                          if (goal == null || goal <= 0) return '—';
                          return '${formatKm(moved)} / ${formatKm(goal)}km';
                        }(),
                      VitalisHabit.swimming => () {
                          final goal = habitsController.swimmingGoalMeters;
                          final moved = habitsController.swimmingMeters;
                          if (goal == null || goal <= 0) return '—';
                          return '${formatKm(moved)} / ${formatKm(goal)}km';
                        }(),
                      VitalisHabit.reading => () {
                          final pages = habitsController.readingPageGoal;
                          if (pages == null) return '—';
                          return '$pages pág.';
                        }(),
                      VitalisHabit.fasting => () {
                          final hours = habitsController.fastingDurationHours;
                          if (hours == null) return '—';
                          return '${hours}h';
                        }(),
                      VitalisHabit.mood => () {
                          final target = habitsController.moodTargetLevel;
                          if (target == null) return '—';
                          return moodLabel(target);
                        }(),
                      VitalisHabit.gym => () {
                          final duration = habitsController.gymDurationMinutes;
                          if (duration == null) return '—';
                          return '${duration}min';
                        }(),
                      VitalisHabit.socialActivities => () {
                          final start = habitsController.socialStartMinutes;
                          if (start == null) return '—';
                          return formatTimeFromMinutes(start);
                        }(),
                      VitalisHabit.martialArts => () {
                          final start = habitsController.martialArtsStartMinutes;
                          if (start == null) return '—';
                          return formatTimeFromMinutes(start);
                        }(),
                      VitalisHabit.dance => () {
                          final start = habitsController.danceStartMinutes;
                          if (start == null) return '—';
                          return formatTimeFromMinutes(start);
                        }(),
                      VitalisHabit.financialGoals => () {
                          final saved = habitsController.financialSavedAmount;
                          final target = habitsController.financialTargetAmount;
                          if (saved == null || target == null || target <= 0) return '—';
                          return '${((saved / target) * 100).clamp(0, 100).round()}%';
                        }(),
                      VitalisHabit.travel => () {
                          final travelDate = habitsController.travelDate;
                          if (travelDate == null) return '—';
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final days = travelDate.difference(today).inDays;
                          if (days <= 0) return 'Hoje';
                          return '${days}d';
                        }(),
                      VitalisHabit.cycling => () {
                          final goal = habitsController.cyclingGoalMeters;
                          if (goal == null || goal <= 0) return '—';
                          return '${formatKm(goal)}km';
                        }(),
                      _ => d.topRightText ?? '50%',
                    };

                    final dynamicProgress = switch (d.habit) {
                      VitalisHabit.hydration => () {
                          final goal = habitsController.hydrationGoalMl;
                          final consumed = habitsController.hydrationConsumedMl;
                          if (goal == null || goal <= 0) return 0.0;
                          return (consumed / goal).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.sleep => () {
                          final goal = habitsController.sleepGoalMinutes;
                          final slept = habitsController.sleepMinutes;
                          if (goal == null || goal <= 0) return 0.0;
                          return (slept / goal).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.movement => () {
                          final goal = habitsController.movementGoalMeters;
                          final moved = habitsController.movementMeters;
                          if (goal == null || goal <= 0) return 0.0;
                          return (moved / goal).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.swimming => () {
                          final goal = habitsController.swimmingGoalMeters;
                          final moved = habitsController.swimmingMeters;
                          if (goal == null || goal <= 0) return 0.0;
                          return (moved / goal).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.reading => () {
                          final pages = habitsController.readingPageGoal;
                          if (pages == null || pages <= 0) return 0.0;
                          return 0.0;
                        }(),
                      VitalisHabit.fasting => () {
                          final hours = habitsController.fastingDurationHours;
                          if (hours == null || hours <= 0) return 0.0;
                          return (hours / 24).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.mood => () {
                          final target = habitsController.moodTargetLevel;
                          if (target == null) return 0.0;
                          return (target / 4).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.gym => () {
                          final duration = habitsController.gymDurationMinutes;
                          if (duration == null) return 0.0;
                          return (duration / 120).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.financialGoals => () {
                          final saved = habitsController.financialSavedAmount;
                          final target = habitsController.financialTargetAmount;
                          if (saved == null || target == null || target <= 0) return 0.0;
                          return (saved / target).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.travel => () {
                          final travelDate = habitsController.travelDate;
                          if (travelDate == null) return 0.0;
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final days = travelDate.difference(today).inDays;
                          if (days <= 0) return 1.0;
                          return (1 / (days + 1)).clamp(0.0, 1.0);
                        }(),
                      VitalisHabit.cycling => () {
                          final goal = habitsController.cyclingGoalMeters;
                          if (goal == null || goal <= 0) return 0.0;
                          return (goal / 60000).clamp(0.0, 1.0);
                        }(),
                      _ => VitalisHabitsCatalog.progress,
                    };

                    return VitalisHabitCard(
                      title: d.title,
                      subtitle: dynamicSubtitle,
                      progress: dynamicProgress,
                      progressColor: d.progressColor,
                      iconAsset: d.iconAsset,
                      iconData: d.iconData,
                      topRightText: dynamicTopRightText,
                      iconBackgroundColor: d.iconBackgroundColor,
                      iconSize: d.iconSize,
                      onPressed: () => handleHabitCardPressed(d.habit, d.title),
                    );
                  },
                ),
              const SizedBox(height: 16),
              VitalisFriendsConnectionCard(onPressed: openPremium),
              const SizedBox(height: 6),
              VitalisPsychologySupportCard(onPressed: openPremium),
              const SizedBox(height: 6),
              VitalisBookRecommendationsCard(onPressed: openPremium),
              const SizedBox(height: 6),
              VitalisMeditationCard(onPressed: openPremium),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({
    required this.progressPercent,
  });

  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percentText = '${(progressPercent * 100).round()}%';

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryContainer,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROGRESSO DIÁRIO',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      percentText,
                      style: textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Quase lá! Você está mantendo\num ótimo ritmo hoje.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.25,
                        fontSize: (textTheme.bodyMedium?.fontSize ?? 14) + 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6EE5C6),
                    width: 6,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 22,
                    color: const Color(0xFF6EE5C6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoHabitsCard extends StatelessWidget {
  const _NoHabitsCard({
    required this.onAddPressed,
  });

  final VoidCallback onAddPressed;

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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.auto_awesome_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oops, parece que você não tem nenhum hábito adicionado a sua rotina.',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clique no botão de adição e selecione os hábitos que desejar!',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.outline,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
