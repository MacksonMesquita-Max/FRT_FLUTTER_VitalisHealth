import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/home/vitalis_image_cta_card.dart';

class VitalisMeditationCard extends StatelessWidget {
  const VitalisMeditationCard({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return VitalisImageCtaCard(
      imageAsset: 'lib/assets/images/backgorundImageMedita.png',
      icon: Icons.self_improvement_outlined,
      iconBackgroundColor: const Color(0xFFFFF1E6),
      title: 'Mantenha a calma e respire\nfundo.',
      description:
          'Sessões guiadas para reduzir estresse, aumentar foco\ne relaxar.',
      actionText: 'Iniciar Meditação',
      onPressed: onPressed,
    );
  }
}
