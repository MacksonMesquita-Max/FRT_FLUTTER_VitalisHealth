import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/habits/vitalis_habits_catalog.dart';
import 'package:vitalis_app/components/components/home/vitalis_bottom_nav_bar.dart';
import 'package:vitalis_app/components/components/home/vitalis_habit_card.dart';
import 'package:vitalis_app/components/components/home/vitalis_motivation_carousel.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedHabits = VitalisHabitsScope.of(context).habits;
    final habitsController = VitalisHabitsScope.of(context);
    final profileController = VitalisUserProfileScope.of(context);
    final userName = profileController.displayName;
    final selectedDefinitions = VitalisHabitsCatalog.definitions
        .where((d) => selectedHabits.contains(d.habit))
        .toList();

    String formatLiters(int ml) {
      final liters = ml / 1000;
      final fixed = liters.toStringAsFixed(1);
      return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
    }

    String formatHours(int minutes) {
      final hours = minutes / 60;
      final fixed = hours.toStringAsFixed(1);
      return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
    }

    String formatKm(int meters) {
      final km = meters / 1000;
      final fixed = km.toStringAsFixed(1);
      return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
    }

    String formatTimeFromMinutes(int totalMinutes) {
      final normalized = totalMinutes.clamp(0, 1439);
      final hour = (normalized ~/ 60).toString().padLeft(2, '0');
      final minute = (normalized % 60).toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    String formatMoney(int amount) {
      final digits = amount.toString();
      final buffer = StringBuffer();
      for (var i = 0; i < digits.length; i++) {
        buffer.write(digits[i]);
        final remaining = digits.length - i - 1;
        if (remaining > 0 && remaining % 3 == 0) {
          buffer.write('.');
        }
      }
      return 'R\$ ${buffer.toString()}';
    }

    String formatDate(DateTime value) {
      final day = value.day.toString().padLeft(2, '0');
      final month = value.month.toString().padLeft(2, '0');
      return '$day/$month/${value.year}';
    }

    String formatDaysOfWeek(Set<int> daysOfWeek) {
      if (daysOfWeek.isEmpty) return '';
      if (daysOfWeek.length >= 7) return 'Todos os dias';
      const labels = <int, String>{
        1: 'Seg',
        2: 'Ter',
        3: 'Qua',
        4: 'Qui',
        5: 'Sex',
        6: 'Sáb',
        7: 'Dom',
      };
      final ordered = daysOfWeek.toList()..sort();
      final text = ordered.map((d) => labels[d]).whereType<String>().join(', ');
      return text.isEmpty ? '' : 'Dias: $text';
    }

    String moodLabel(int level) {
      return switch (level.clamp(0, 4)) {
        0 => 'Radiante',
        1 => 'Feliz',
        2 => 'Calmo',
        3 => 'Ansioso',
        _ => 'Triste',
      };
    }

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
                      Text(
                        'Vitalis',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const VitalisUserAvatar(),
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
              const VitalisMotivationCarousel(
                quotes: [
                  VitalisQuote(
                    text: 'A persistência é o caminho do êxito.',
                    author: 'Charles Chaplin',
                  ),
                  VitalisQuote(
                    text: 'Não reze por uma vida fácil, reze por forças para suportar uma difícil.',
                    author: 'Bruce Lee',
                  ),
                  VitalisQuote(
                    text: 'O que não provoca minha morte faz com que eu fique mais forte.',
                    author: 'Friedrich Nietzsche',
                  ),
                  VitalisQuote(
                    text:
                        'A vida não é fácil para nenhum de nós. Temos que ter persistência e, acima de tudo, confiança em nós mesmos.',
                    author: 'Marie Curie',
                  ),
                  VitalisQuote(
                    text:
                        'Sem disciplina, o talento não serve pra nada.',
                    author: 'Cristiano Ronaldo',
                  ),
                  VitalisQuote(
                    text:
                        'Na vida, não existem soluções. Existem forças em marcha: é preciso criá-las e, então, a elas seguem-se as soluções.',
                    author: 'Antoine de Saint-Exupéry',
                  ),
                  VitalisQuote(
                    text:
                        'Não é preciso ter olhos abertos para ver o sol, Para ser vitorioso você precisa ver o que não está visível.',
                    author: 'Sun Tzu',
                  ),
                  VitalisQuote(
                    text:
                        'Acima de tudo, não tenha medo dos momentos difíceis. O que há de melhor vem com eles.',
                    author: 'Rita Levi Montalcini',
                  ),
                  VitalisQuote(
                    text:
                        'Pois que aproveita ao homem se ganhar o mundo inteiro e perder a sua alma? Ou que dará o homem em troca da sua vida?',
                    author: 'Jesus Cristo',
                  ),
                ],
              ),
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
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImageWinnerFriends.png',
                icon: Icons.groups_outlined,
                iconBackgroundColor: const Color(0xFFEAF9F0),
                title: 'Conecte-se com seus amigos\ne pratique disputas saudáveis!',
                description: 'A motivação é maior quando compartilhada.\nCrie desafios e celebre vitórias juntos.',
                actionText: 'Iniciar Conexão',
                onPressed: openPremium,
              ),
              const SizedBox(height: 6),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImagePisicology.png',
                icon: Icons.psychology_outlined,
                iconBackgroundColor: const Color(0xFFEDEFFF),
                title: 'Precisa de ajuda?\nConte com nossa equipe de psicólogos.',
                description: 'Uma mente merece cuidado profissional.\nEncontre suporte quando mais precisar.',
                actionText: 'Ver Mais',
                onPressed: openPremium,
              ),
              const SizedBox(height: 6),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImageLibrary.png',
                icon: Icons.menu_book_outlined,
                iconBackgroundColor: const Color(0xFFEAF2FF),
                title: 'Sem boas leituras?\nConfira nossa lista de livros!',
                description: 'Expanda seus horizontes com curadorias\nfocadas em desenvolvimento pessoal.',
                actionText: 'Ver Mais',
                onPressed: openPremium,
              ),
              const SizedBox(height: 6),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImageMedita.png',
                icon: Icons.self_improvement_outlined,
                iconBackgroundColor: const Color(0xFFFFF1E6),
                title: 'Mantenha a calma e respire\nfundo.',
                description: 'Sessões guiadas para reduzir estresse, aumentar foco\ne relaxar.',
                actionText: 'Iniciar Meditação',
                onPressed: openPremium,
              ),
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

class _ImageCtaCard extends StatelessWidget {
  const _ImageCtaCard({
    required this.imageAsset,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.actionText,
    this.onPressed,
  });

  final String imageAsset;
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final String actionText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.surfaceContainer, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(icon, color: AppColors.secondary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.outline,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          actionText,
                          style: textTheme.labelLarge?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceContainer, width: 1),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imageAsset,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
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
