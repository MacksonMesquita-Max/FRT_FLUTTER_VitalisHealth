import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';

class HydrationHabitSettingsScreen extends StatefulWidget {
  const HydrationHabitSettingsScreen({super.key});

  @override
  State<HydrationHabitSettingsScreen> createState() => _HydrationHabitSettingsScreenState();
}

enum _HydrationSex {
  masculino,
  feminino,
}

class _HydrationHabitSettingsScreenState extends State<HydrationHabitSettingsScreen> {
  _HydrationSex _sex = _HydrationSex.masculino;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _manualGoalController = TextEditingController();

  String? _weightError;
  String? _ageError;
  String? _manualGoalError;
  int? _calculatedGoalMl;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _manualGoalController.dispose();
    super.dispose();
  }

  int _mlPerKgForAge(int age) {
    if (age <= 17) return 40;
    if (age <= 55) return 35;
    if (age <= 65) return 30;
    return 25;
  }

  double _toDouble(String value) {
    return double.parse(value.replaceAll(',', '.').trim());
  }

  int? _tryParseInt(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  void _validateAndCalculate() {
    setState(() {
      _weightError = null;
      _ageError = null;
    });

    final weightText = _weightController.text.trim();
    final ageText = _ageController.text.trim();

    double? weightKg;
    int? age;

    try {
      if (weightText.isEmpty) {
        _weightError = 'Informe seu peso.';
      } else {
        weightKg = _toDouble(weightText);
        if (weightKg <= 0) _weightError = 'Peso inválido.';
      }
    } catch (_) {
      _weightError = 'Peso inválido.';
    }

    age = _tryParseInt(ageText);
    if (ageText.isEmpty) {
      _ageError = 'Informe sua idade.';
    } else if (age == null || age <= 0) {
      _ageError = 'Idade inválida.';
    }

    if (_weightError != null || _ageError != null) {
      setState(() => _calculatedGoalMl = null);
      return;
    }

    final mlPerKg = _mlPerKgForAge(age!);
    final rawMl = (weightKg! * mlPerKg);
    setState(() => _calculatedGoalMl = rawMl.round());
  }

  String _formatMl(int ml) {
    return ml.toString();
  }

  Future<void> _confirm() async {
    setState(() {
      _manualGoalError = null;
    });

    final manualGoalMl = _tryParseInt(_manualGoalController.text.trim());
    final goalMl = (manualGoalMl != null && manualGoalMl > 0) ? manualGoalMl : _calculatedGoalMl;

    if (goalMl == null || goalMl <= 0) {
      setState(() => _manualGoalError = 'Defina uma meta manual ou calcule a meta personalizada.');
      return;
    }

    VitalisHabitsScope.of(context).setHydrationGoalMl(goalMl);
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
                trailing: const Icon(Icons.check, size: 18),
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
                      'Configuração de Hidratação',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
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
                        height: 140,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'lib/assets/images/waterForHabits.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.15),
                                      Colors.black.withValues(alpha: 0.45),
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
                                    'Defina seu Equilíbrio\nDiário',
                                    style: textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      icon: Icons.person_outline,
                      iconBackgroundColor: const Color(0xFFEAF9F0),
                      title: 'Meta Personalizada',
                      description:
                          'Calcule sua ingestão ideal de água com base\nno seu peso e na sua média etária.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'SEXO',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _ChoicePill(
                                  label: 'Masculino',
                                  selected: _sex == _HydrationSex.masculino,
                                  onTap: () => setState(() => _sex = _HydrationSex.masculino),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _ChoicePill(
                                  label: 'Feminino',
                                  selected: _sex == _HydrationSex.feminino,
                                  onTap: () => setState(() => _sex = _HydrationSex.feminino),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _LabeledField(
                                  label: 'PESO (KG)',
                                  child: VitalisTextField(
                                    hintText: '70',
                                    controller: _weightController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    errorText: _weightError,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _LabeledField(
                                  label: 'ALTURA (CM)',
                                  child: VitalisTextField(
                                    hintText: '175',
                                    controller: _heightController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _LabeledField(
                            label: 'IDADE',
                            child: VitalisTextField(
                              hintText: '30',
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              errorText: _ageError,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _validateAndCalculate,
                            icon: const Icon(Icons.calculate_outlined, size: 18),
                            label: const Text('Calcular'),
                          ),
                          if (_calculatedGoalMl != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'Meta sugerida: ${_formatMl(_calculatedGoalMl!)} ml/dia',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionCard(
                      icon: Icons.tune,
                      iconBackgroundColor: const Color(0xFFEAF2FF),
                      title: 'Meta Manual',
                      description:
                          'Defina a sua meta diária em ml.\nSe preferir, use a meta calculada automaticamente.',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF9F0),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Opcional',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'META DIÁRIA (ML)',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: VitalisTextField(
                                  hintText: 'ex. 2500',
                                  controller: _manualGoalController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  errorText: _manualGoalError,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'ml',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.outline,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Se você já conhece sua ingestão recomendada por um profissional\nde saúde, pode defini-la manualmente aqui.',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.outline,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ReferenceTableCard(),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF9F0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.water_drop_outlined, color: AppColors.secondary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '“A hidratação afeta sua energia, foco e\nrecuperação física. Tente dar goles\nconstantes ao longo do dia.”',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurface,
                                    height: 1.25,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    this.trailing,
    required this.child,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: textTheme.titleSmall?.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (trailing != null) trailing!,
                          ],
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
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.surfaceContainerLow : Colors.white,
        foregroundColor: AppColors.onSurface,
        side: BorderSide(
          color: selected ? AppColors.outlineVariant : AppColors.surfaceContainer,
          width: 1.1,
        ),
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.outline,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ReferenceTableCard extends StatelessWidget {
  const _ReferenceTableCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget cell(String text, {bool header = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          text,
          style: (header ? textTheme.labelLarge : textTheme.bodySmall)?.copyWith(
            color: header ? AppColors.onSurface : AppColors.outline,
            fontWeight: header ? FontWeight.w900 : FontWeight.w600,
            height: 1.2,
          ),
        ),
      );
    }

    TableRow row(String left, String right) {
      return TableRow(
        decoration: const BoxDecoration(color: Colors.white),
        children: [
          cell(left),
          cell(right),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.surfaceContainer, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Text(
                'Tabela de referência (educacional)',
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: AppColors.surfaceContainer, width: 1),
                verticalInside: BorderSide(color: AppColors.surfaceContainer, width: 1),
                top: BorderSide(color: AppColors.surfaceContainer, width: 1),
                bottom: BorderSide(color: AppColors.surfaceContainer, width: 1),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow),
                  children: [
                    cell('Grupo Etário', header: true),
                    cell('Quantidade de Água por kg', header: true),
                  ],
                ),
                row('Jovens até os 17 anos', '40 ml por kg'),
                row('De 18 a 55 anos', '35 ml por kg'),
                row('De 55 a 65 anos', '30 ml por kg'),
                row('66 anos em diante', '25 ml por kg'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Text(
                'Exemplo: 70 kg × 35 ml = 2450 ml (≈ 2,4 L).',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
