import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/screens/premium/premium_terms_screen.dart';

class VitalisPremiumScreen extends StatefulWidget {
  const VitalisPremiumScreen({super.key});

  @override
  State<VitalisPremiumScreen> createState() => _VitalisPremiumScreenState();
}

enum _PlanOption {
  gratuito,
  mensal,
  anual,
}

class _VitalisPremiumScreenState extends State<VitalisPremiumScreen> {
  _PlanOption _selectedPlan = _PlanOption.anual;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 6),
                  Text(
                    'Vitalis Premium',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PremiumTermsScreen(showConsentActions: false),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    color: AppColors.onSurface,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _PremiumHeroCard(),
              const SizedBox(height: 18),
              Text(
                'Escolha seu plano',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: 'Vitalis Gratuito',
                price: 'R\$ 00,00',
                priceSuffix: '/mês',
                selected: _selectedPlan == _PlanOption.gratuito,
                leadingIcon: Icons.calendar_month_outlined,
                value: _PlanOption.gratuito,
                groupValue: _selectedPlan,
                onChanged: (value) => setState(() => _selectedPlan = value),
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: 'Vitalis Premium',
                price: 'R\$ 17,90',
                priceSuffix: '/mês',
                selected: _selectedPlan == _PlanOption.mensal,
                leadingIcon: Icons.calendar_month_outlined,
                value: _PlanOption.mensal,
                groupValue: _selectedPlan,
                onChanged: (value) => setState(() => _selectedPlan = value),
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: 'Vitalis Premium (Pacote anual)',
                price: 'R\$ 199,99',
                priceSuffix: '/ano',
                selected: _selectedPlan == _PlanOption.anual,
                leadingIcon: Icons.calendar_month_outlined,
                badgeText: 'Mais rentável',
                value: _PlanOption.anual,
                groupValue: _selectedPlan,
                onChanged: (value) => setState(() => _selectedPlan = value),
              ),
              const SizedBox(height: 16),
              VitalisPrimaryButton(
                label: 'Selecionar plano ativo',
                trailing: const Icon(Icons.arrow_forward, size: 18),
                onPressed: () async {
                  final accepted = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const PremiumTermsScreen(showConsentActions: true),
                    ),
                  );
                  if (!context.mounted) return;
                  if (accepted == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfeito! Vamos seguir com a assinatura.')),
                    );
                  } else if (accepted == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tudo bem! Você pode assinar quando quiser.')),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Cancele a qualquer momento. Pagamento seguro.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Vantagens do Premium',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              const _BenefitsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumHeroCard extends StatelessWidget {
  const _PremiumHeroCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/forrestForPremiumPage.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.55),
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
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      'UPGRADE',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Eleve sua jornada\npara o próximo nível!',
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Desbloqueie ferramentas exclusivas desenhadas para seu bem-estar e crescimento pessoal constante.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.priceSuffix,
    required this.selected,
    required this.leadingIcon,
    this.badgeText,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String price;
  final String priceSuffix;
  final bool selected;
  final IconData leadingIcon;
  final String? badgeText;
  final _PlanOption value;
  final _PlanOption groupValue;
  final ValueChanged<_PlanOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.secondary : AppColors.surfaceContainer,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(leadingIcon, color: AppColors.primary),
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
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          price,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          priceSuffix,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.outline,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              badgeText!,
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Radio<_PlanOption>(
                value: value,
                groupValue: groupValue,
                onChanged: (newValue) {
                  if (newValue == null) return;
                  onChanged(newValue);
                },
                activeColor: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            children: const [
              _BenefitRow(
                icon: Icons.menu_book_outlined,
                iconBackground: Color(0xFFEAF9F0),
                title: 'Biblioteca Premium',
                description:
                    'Acesso ilimitado a uma ampla coleção de livros e artigos científicos voltados ao bem-estar, ao desenvolvimento pessoal e ao aprimoramento contínuo.',
              ),
              SizedBox(height: 14),
              _BenefitRow(
                icon: Icons.insights_outlined,
                iconBackground: Color(0xFFEAF2FF),
                title: 'Estatísticas Avançadas',
                description:
                    'Relatórios detalhados de sono, humor e tendências de bem-estar semanal.',
              ),
              SizedBox(height: 14),
              _BenefitRow(
                icon: Icons.groups_outlined,
                iconBackground: Color(0xFFFFF1E6),
                title: 'Desafios Exclusivos',
                description:
                    'Participe de jogos coletivos e desafios exclusivos com seus amigos.',
              ),
              SizedBox(height: 14),
              _BenefitRow(
                icon: Icons.psychology_outlined,
                iconBackground: Color(0xFFEDEFFF),
                title: 'Psicólogos Parceiros',
                description:
                    'Acesso a uma rede exclusiva de psicólogos parceiros para atendimento online especializado.',
              ),
              SizedBox(height: 14),
              _BenefitRow(
                icon: Icons.fitness_center_outlined,
                iconBackground: Color(0xFFEAF9F0),
                title: 'Exercícios Personalizados',
                description:
                    'Planos de yoga, corrida e natação adaptados aos seus objetivos e nível de condicionamento.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(icon, color: AppColors.primary),
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
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
