import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class SelectHabitsScreen extends StatefulWidget {
  const SelectHabitsScreen({super.key});

  @override
  State<SelectHabitsScreen> createState() => _SelectHabitsScreenState();
}

class _SelectHabitsScreenState extends State<SelectHabitsScreen> {
  final Set<VitalisHabit> _selected = {};
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _selected.addAll(VitalisHabitsScope.of(context).habits);
    _initialized = true;
  }

  void _toggle(VitalisHabit habit) {
    setState(() {
      if (_selected.contains(habit)) {
        _selected.remove(habit);
      } else {
        _selected.add(habit);
      }
    });
  }

  Future<void> _handleAdd() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione ao menos um hábito.'),
          behavior: SnackBarBehavior.fixed,
        ),
      );
      return;
    }

    VitalisHabitsScope.of(context).addAll(_selected);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sucesso! hábitos novos foram adicionados a sua rotina.'),
        behavior: SnackBarBehavior.fixed,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 8),
                  Text(
                    'Escolha seus Novos Hábitos',
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'O que você quer\ncultivar hoje?',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Selecione os hábitos que deseja incluir na sua\nrotina.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.outline,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 18),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.05,
                      children: [
                        _HabitTile(
                          title: 'Movimento',
                          iconAsset: 'lib/assets/icons/running.png',
                          isSelected: _selected.contains(VitalisHabit.movement),
                          onTap: () => _toggle(VitalisHabit.movement),
                        ),
                        _HabitTile(
                          title: 'Sono',
                          iconAsset: 'lib/assets/icons/moon.svg',
                          isSelected: _selected.contains(VitalisHabit.sleep),
                          onTap: () => _toggle(VitalisHabit.sleep),
                        ),
                        _HabitTile(
                          title: 'Hidratação',
                          iconAsset: 'lib/assets/icons/water_drop.svg',
                          isSelected: _selected.contains(VitalisHabit.hydration),
                          onTap: () => _toggle(VitalisHabit.hydration),
                        ),
                        _HabitTile(
                          title: 'Humor',
                          iconAsset: 'lib/assets/icons/mood.svg',
                          isSelected: _selected.contains(VitalisHabit.mood),
                          onTap: () => _toggle(VitalisHabit.mood),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    VitalisPrimaryButton(
                      label: 'Adicionar',
                      trailing: const Icon(Icons.add, size: 18),
                      onPressed: _handleAdd,
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

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required this.title,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSvg = iconAsset.toLowerCase().endsWith('.svg');
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.secondary : AppColors.surfaceContainer,
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Center(
                        child: isSvg
                            ? SvgPicture.asset(
                                iconAsset,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Image.asset(
                                iconAsset,
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
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
