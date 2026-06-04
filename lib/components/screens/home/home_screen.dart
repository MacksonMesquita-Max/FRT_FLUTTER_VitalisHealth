import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_bottom_nav_bar.dart';
import 'package:vitalis_app/components/common/vitalis_habits_catalog.dart';
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
    final selectedDefinitions = VitalisHabitsCatalog.definitions
        .where((d) => selectedHabits.contains(d.habit))
        .toList();

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
                    return VitalisHabitCard(
                      title: d.title,
                      subtitle: d.subtitle ?? '50% concluído',
                      progress: VitalisHabitsCatalog.progress,
                      progressColor: d.progressColor,
                      iconAsset: d.iconAsset,
                      topRightText: d.topRightText ?? '50%',
                      iconBackgroundColor: d.iconBackgroundColor,
                      iconSize: d.iconSize,
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
                description: 'Sessões guiadas para reduzir estresse,\naumentar foco e relaxar.',
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
