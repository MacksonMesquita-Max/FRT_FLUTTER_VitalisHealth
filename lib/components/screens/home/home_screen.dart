import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_bottom_nav_bar.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_habit_card.dart';
import 'package:vitalis_app/components/common/vitalis_motivation_carousel.dart';
import 'package:vitalis_app/components/common/vitalis_user_avatar.dart';
import 'package:vitalis_app/components/screens/habits/select_habits_screen.dart';
import 'package:vitalis_app/components/screens/premium/vitalis_premium_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedHabits = VitalisHabitsScope.of(context).habits;

    void openPremium() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VitalisPremiumScreen(),
        ),
      );
    }

    Future<void> openSelectHabits() async {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const SelectHabitsScreen()),
      );
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
      bottomNavigationBar: const VitalisBottomNavBar(),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configurações em breve.')),
                      );
                    },
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
                'Como você está se sentindo hoje?\nReserve um momento para você.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.outline,
                  height: 1.25,
                  fontSize: (textTheme.bodyMedium?.fontSize ?? 14) + 1,
                ),
              ),
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
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.13,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if (selectedHabits.contains(VitalisHabit.hydration))
                      const VitalisHabitCard(
                        title: 'Hidratação',
                        subtitle: 'Faltam apenas 500ml',
                        progress: 6 / 8,
                        progressColor: Color(0xFF2E79FF),
                        iconAsset: 'lib/assets/icons/water_drop.svg',
                        topRightText: '6/8',
                        iconBackgroundColor: Color(0xFFEAF2FF),
                      ),
                    if (selectedHabits.contains(VitalisHabit.sleep))
                      const VitalisHabitCard(
                        title: 'Sono',
                        subtitle: 'Qualidade boa',
                        progress: 0.82,
                        progressColor: Color(0xFF6B78FF),
                        iconAsset: 'lib/assets/icons/moon.svg',
                        topRightText: '7h 20m',
                        iconBackgroundColor: Color(0xFFEDEFFF),
                      ),
                    if (selectedHabits.contains(VitalisHabit.movement))
                      const VitalisHabitCard(
                        title: 'Movimento',
                        subtitle: 'Caminhada ativa',
                        progress: 0.58,
                        progressColor: Color(0xFFFF8A34),
                        iconAsset: 'lib/assets/icons/running.png',
                        topRightText: '4.2km',
                        iconBackgroundColor: Color(0xFFFFF1E6),
                        iconSize: 22,
                      ),
                    if (selectedHabits.contains(VitalisHabit.mood))
                      VitalisHabitCard(
                        title: 'Humor',
                        subtitle: 'Radiante e Calmo',
                        progress: 0.72,
                        progressColor: const Color(0xFF46C37B),
                        iconAsset: 'lib/assets/icons/mood.svg',
                        iconBackgroundColor: const Color(0xFFEAF9F0),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                          color: AppColors.outline,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          iconSize: 18,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 16),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImageWinnerFriends.png',
                title: 'Conecte-se com seus amigos\ne pratique disputas saudáveis!',
                actionText: 'Iniciar Conexão',
                onPressed: openPremium,
              ),
              const SizedBox(height: 6),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImagePisicology.png',
                title: 'Precisa de ajuda?\nConte com nossa equipe de psicólogos.',
                actionText: 'Ver Mais',
                onPressed: openPremium,
              ),
              const SizedBox(height: 6),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImageLibrary.png',
                title: 'Sem boas leituras?\nConfira nossa lista de livros!',
                actionText: 'Ver Mais',
                onPressed: openPremium,
              ),
              const SizedBox(height: 6),
              _ImageCtaCard(
                imageAsset: 'lib/assets/images/backgorundImageMedita.png',
                title: 'Mantenha a calma e respire\nfundo.',
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
    required this.title,
    required this.actionText,
    this.onPressed,
  });

  final String imageAsset;
  final String title;
  final String actionText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 180,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.06),
                          Colors.black.withValues(alpha: 0.32),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        actionText,
                        style: textTheme.titleSmall?.copyWith(
                          color: const Color(0xFFBDF3E4),
                          fontWeight: FontWeight.w700,
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
