import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';

class FastingHabitSettingsScreen extends StatefulWidget {
  const FastingHabitSettingsScreen({super.key});

  @override
  State<FastingHabitSettingsScreen> createState() => _FastingHabitSettingsScreenState();
}

class _FastingHabitSettingsScreenState extends State<FastingHabitSettingsScreen> {
  final _purposeController = TextEditingController();
  double _durationHours = 8;
  String? _purposeError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final controller = VitalisHabitsScope.of(context);
    _purposeController.text = controller.fastingPurpose ?? '';
    _durationHours = (controller.fastingDurationHours ?? 8).clamp(0, 24).toDouble();
    _initialized = true;
  }

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final purpose = _purposeController.text.trim();
    setState(() {
      _purposeError = purpose.isEmpty ? 'Informe o propósito do jejum.' : null;
    });
    if (_purposeError != null) return;

    VitalisHabitsScope.of(context).setFastingPlan(
      purpose: purpose,
      durationHours: _durationHours.round(),
    );
    Navigator.of(context).pop(true);
  }

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
                label: 'Confirmar Configuração',
                trailing: const Icon(Icons.check_circle_outline, size: 18),
                onPressed: _confirm,
              ),
              const SizedBox(height: 10),
              Text(
                'Você pode atualizar essas configurações a qualquer momento em seu perfil.',
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
                      'Vitalis',
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
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 190,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'lib/assets/images/fastForHabits.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) {
                                  return DecoratedBox(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF8A4B1B),
                                          Color(0xFFC96E27),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.restaurant_outlined,
                                        size: 56,
                                        color: Colors.white.withValues(alpha: 0.92),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.05),
                                      Colors.black.withValues(alpha: 0.48),
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
                                    'PERSONALIZE SEU FLUXO',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Meta de Jejum',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.08,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Equilibrio entre corpo e mente.',
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
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Propósito do jejum',
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    VitalisTextField(
                      hintText: 'Ex: Autoconhecimento e Saúde',
                      controller: _purposeController,
                      textInputAction: TextInputAction.done,
                      errorText: _purposeError,
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'Duração do jejum',
                      trailing: Text(
                        '${_durationHours.round()}h',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.secondary,
                              inactiveTrackColor: AppColors.surfaceContainer,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.secondary.withValues(alpha: 0.12),
                              trackHeight: 3.5,
                            ),
                            child: Slider(
                              value: _durationHours,
                              min: 0,
                              max: 24,
                              divisions: 6,
                              onChanged: (value) => setState(() => _durationHours = value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '0h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  '4h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  '8h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  '12h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  '16h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  '20h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  '24h',
                                  style: textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _NoticeCard(
                      accentColor: Color(0xFF63F089),
                      iconColor: AppColors.secondary,
                      icon: Icons.water_drop_outlined,
                      title: 'Recomendações Médicas',
                      description:
                          'Mantenha-se hidratado durante todo o período. Água, chás e café sem açúcar são permitidos e essenciais para o bom funcionamento metabólico.',
                    ),
                    const SizedBox(height: 14),
                    const _NoticeCard(
                      accentColor: Color(0xFFE53935),
                      iconColor: Color(0xFFE53935),
                      icon: Icons.warning_amber_outlined,
                      title: 'Avisos de Cuidado',
                      description:
                          'Escute seu corpo. Interrompa o jejum imediatamente se sentir tontura, fraqueza excessiva ou mal-estar generalizado.',
                    ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.trailing,
    required this.child,
  });

  final String title;
  final Widget? trailing;
  final Widget child;

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
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.accentColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Color accentColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String description;

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 128,
              color: accentColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: iconColor, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                             title,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurface,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
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
