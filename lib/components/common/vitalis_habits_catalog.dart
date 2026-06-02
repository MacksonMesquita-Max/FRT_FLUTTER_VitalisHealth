import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';

class VitalisHabitDefinition {
  const VitalisHabitDefinition({
    required this.habit,
    required this.title,
    required this.iconAsset,
    required this.progressColor,
    required this.iconBackgroundColor,
    this.subtitle,
    this.topRightText,
    this.iconSize = 22,
  });

  final VitalisHabit habit;
  final String title;
  final String iconAsset;
  final String? subtitle;
  final String? topRightText;
  final Color progressColor;
  final Color iconBackgroundColor;
  final double iconSize;
}

abstract final class VitalisHabitsCatalog {
  static const _progress = 0.5;

  static const progress = _progress;

  static const definitions = <VitalisHabitDefinition>[
    VitalisHabitDefinition(
      habit: VitalisHabit.hydration,
      title: 'Hidratação',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/water_drop.svg',
      progressColor: Color(0xFF2E79FF),
      iconBackgroundColor: Color(0xFFEAF2FF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.sleep,
      title: 'Sono',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/moon.svg',
      progressColor: Color(0xFF6B78FF),
      iconBackgroundColor: Color(0xFFEDEFFF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.movement,
      title: 'Movimento',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/running.png',
      progressColor: Color(0xFFFF8A34),
      iconBackgroundColor: Color(0xFFFFF1E6),
      iconSize: 22,
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.mood,
      title: 'Humor',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/mood.svg',
      progressColor: Color(0xFF46C37B),
      iconBackgroundColor: Color(0xFFEAF9F0),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.gym,
      title: 'Academia',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/gym.svg',
      progressColor: Color(0xFF46C37B),
      iconBackgroundColor: Color(0xFFEAF9F0),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.swimming,
      title: 'Natação',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/swimming.svg',
      progressColor: Color(0xFF2E79FF),
      iconBackgroundColor: Color(0xFFEAF2FF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.reading,
      title: 'Leitura',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/reading.svg',
      progressColor: Color(0xFF6B78FF),
      iconBackgroundColor: Color(0xFFEDEFFF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.fasting,
      title: 'Jejum',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/fasting.svg',
      progressColor: Color(0xFFFF8A34),
      iconBackgroundColor: Color(0xFFFFF1E6),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.extraNotifications,
      title: 'Notificações',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/notifications.svg',
      progressColor: Color(0xFF6B78FF),
      iconBackgroundColor: Color(0xFFEDEFFF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.religious,
      title: 'Religioso',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/religious.svg',
      progressColor: Color(0xFF46C37B),
      iconBackgroundColor: Color(0xFFEAF9F0),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.drawingPainting,
      title: 'Desenho/Pintura',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/art.svg',
      progressColor: Color(0xFFFF8A34),
      iconBackgroundColor: Color(0xFFFFF1E6),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.languages,
      title: 'Idiomas',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/languages.svg',
      progressColor: Color(0xFF2E79FF),
      iconBackgroundColor: Color(0xFFEAF2FF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.medicineTime,
      title: 'Hora do remédio',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/medicine.svg',
      progressColor: Color(0xFF46C37B),
      iconBackgroundColor: Color(0xFFEAF9F0),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.studies,
      title: 'Estudos',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/studies.svg',
      progressColor: Color(0xFF6B78FF),
      iconBackgroundColor: Color(0xFFEDEFFF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.climbing,
      title: 'Escalada',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/climbing.svg',
      progressColor: Color(0xFFFF8A34),
      iconBackgroundColor: Color(0xFFFFF1E6),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.music,
      title: 'Música',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/music.svg',
      progressColor: Color(0xFF6B78FF),
      iconBackgroundColor: Color(0xFFEDEFFF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.trail,
      title: 'Trilha',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/trail.svg',
      progressColor: Color(0xFF46C37B),
      iconBackgroundColor: Color(0xFFEAF9F0),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.socialActivities,
      title: 'Social',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/social.svg',
      progressColor: Color(0xFF2E79FF),
      iconBackgroundColor: Color(0xFFEAF2FF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.martialArts,
      title: 'Artes marciais',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/martial_arts.svg',
      progressColor: Color(0xFFFF8A34),
      iconBackgroundColor: Color(0xFFFFF1E6),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.dance,
      title: 'Dança',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/dance.svg',
      progressColor: Color(0xFF6B78FF),
      iconBackgroundColor: Color(0xFFEDEFFF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.financialGoals,
      title: 'Finanças',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/finance.svg',
      progressColor: Color(0xFF46C37B),
      iconBackgroundColor: Color(0xFFEAF9F0),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.travel,
      title: 'Viagens',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/travel.svg',
      progressColor: Color(0xFF2E79FF),
      iconBackgroundColor: Color(0xFFEAF2FF),
    ),
    VitalisHabitDefinition(
      habit: VitalisHabit.cycling,
      title: 'Ciclismo',
      subtitle: '50% concluído',
      topRightText: '50%',
      iconAsset: 'lib/assets/icons/cycling.svg',
      progressColor: Color(0xFFFF8A34),
      iconBackgroundColor: Color(0xFFFFF1E6),
    ),
  ];

  static VitalisHabitDefinition definitionFor(VitalisHabit habit) {
    return definitions.firstWhere((d) => d.habit == habit);
  }
}
