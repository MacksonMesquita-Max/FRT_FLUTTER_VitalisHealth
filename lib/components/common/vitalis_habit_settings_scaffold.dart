import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class VitalisHabitSettingsSpec {
  const VitalisHabitSettingsSpec({
    required this.appBarTitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.backgroundImageAsset,
    this.heroHeight = 190,
    this.imageAlignment = Alignment.center,
  });

  static const heroEyebrow = 'PERSONALIZE SEU FLUXO';
  static const footerMessage =
      'Você pode atualizar essas configurações a qualquer momento em seu perfil.';

  final String appBarTitle;
  final String heroTitle;
  final String heroSubtitle;
  final String backgroundImageAsset;
  final double heroHeight;
  final Alignment imageAlignment;
}

class VitalisHabitSettingsScaffold extends StatelessWidget {
  const VitalisHabitSettingsScaffold({
    super.key,
    required this.spec,
    required this.onConfirm,
    required this.children,
    this.confirmLabel = 'Confirmar Configuração',
    this.confirmTrailing,
    this.contentPadding = const EdgeInsets.fromLTRB(18, 0, 18, 18),
  });

  final VitalisHabitSettingsSpec spec;
  final VoidCallback onConfirm;
  final List<Widget> children;
  final String confirmLabel;
  final Widget? confirmTrailing;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VitalisPrimaryButton(
                label: confirmLabel,
                trailing: confirmTrailing,
                onPressed: onConfirm,
              ),
              const SizedBox(height: 10),
              Text(
                VitalisHabitSettingsSpec.footerMessage,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      spec.appBarTitle,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _VitalisHabitHeroCard(spec: spec),
                    const SizedBox(height: 18),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalisHabitHeroCard extends StatelessWidget {
  const _VitalisHabitHeroCard({
    required this.spec,
  });

  final VitalisHabitSettingsSpec spec;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: spec.heroHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                spec.backgroundImageAsset,
                fit: BoxFit.cover,
                alignment: spec.imageAlignment,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.52),
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
                    VitalisHabitSettingsSpec.heroEyebrow,
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spec.heroTitle,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spec.heroSubtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
