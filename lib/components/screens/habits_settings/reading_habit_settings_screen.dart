import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';

class ReadingHabitSettingsScreen extends StatefulWidget {
  const ReadingHabitSettingsScreen({super.key});

  @override
  State<ReadingHabitSettingsScreen> createState() => _ReadingHabitSettingsScreenState();
}

class _ReadingHabitSettingsScreenState extends State<ReadingHabitSettingsScreen> {
  final _bookController = TextEditingController();
  final Set<int> _selectedDays = {};
  double _pageGoal = 20;
  String? _bookError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final controller = VitalisHabitsScope.of(context);
    _bookController.text = controller.readingBookName ?? '';
    _pageGoal = (controller.readingPageGoal ?? 20).clamp(1, 100).toDouble();
    _selectedDays.addAll(controller.readingDaysOfWeek);
    _initialized = true;
  }

  @override
  void dispose() {
    _bookController.dispose();
    super.dispose();
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _confirm() async {
    final bookName = _bookController.text.trim();
    setState(() {
      _bookError = bookName.isEmpty ? 'Informe o nome do livro.' : null;
    });
    if (_bookError != null) return;

    VitalisHabitsScope.of(context).setReadingPlan(
      bookName: bookName,
      pageGoal: _pageGoal.round(),
      daysOfWeek: _selectedDays,
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
                                'lib/assets/images/readForHabits.png',
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
                                      Colors.black.withValues(alpha: 0.06),
                                      Colors.black.withValues(alpha: 0.50),
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
                                    'Sua Próxima Leitura',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.08,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'O conhecimento é o melhor investimento.',
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
                      'NOME DO LIVRO',
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    VitalisTextField(
                      hintText: 'Ex: O Alquimista',
                      controller: _bookController,
                      textInputAction: TextInputAction.done,
                      errorText: _bookError,
                      suffixIcon: const Icon(
                        Icons.bookmark_border,
                        color: AppColors.outlineVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'META DE PÁGINAS',
                      trailing: Text(
                        '${_pageGoal.round()} páginas',
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w400,
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
                              value: _pageGoal,
                              min: 1,
                              max: 100,
                              divisions: 99,
                              onChanged: (value) => setState(() => _pageGoal = value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: AppColors.outlineVariant,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '50',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: AppColors.outlineVariant,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '100',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: AppColors.outlineVariant,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'DIAS DA SEMANA',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.surfaceContainer, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _WeekDayButton(
                                label: 'D',
                                selected: _selectedDays.contains(7),
                                onTap: () => _toggleDay(7),
                              ),
                              _WeekDayButton(
                                label: 'S',
                                selected: _selectedDays.contains(1),
                                onTap: () => _toggleDay(1),
                              ),
                              _WeekDayButton(
                                label: 'T',
                                selected: _selectedDays.contains(2),
                                onTap: () => _toggleDay(2),
                              ),
                              _WeekDayButton(
                                label: 'Q',
                                selected: _selectedDays.contains(3),
                                onTap: () => _toggleDay(3),
                              ),
                              _WeekDayButton(
                                label: 'Q',
                                selected: _selectedDays.contains(4),
                                onTap: () => _toggleDay(4),
                              ),
                              _WeekDayButton(
                                label: 'S',
                                selected: _selectedDays.contains(5),
                                onTap: () => _toggleDay(5),
                              ),
                              _WeekDayButton(
                                label: 'S',
                                selected: _selectedDays.contains(6),
                                onTap: () => _toggleDay(6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lembretes serão enviados às 20h nos dias selecionados.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.outlineVariant,
                        height: 1.3,
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

class _WeekDayButton extends StatelessWidget {
  const _WeekDayButton({
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.surfaceContainer,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              color: selected ? Colors.white : AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
