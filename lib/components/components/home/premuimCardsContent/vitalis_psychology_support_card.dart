import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/home/vitalis_image_cta_card.dart';

class VitalisPsychologySupportCard extends StatelessWidget {
  const VitalisPsychologySupportCard({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return VitalisImageCtaCard(
      imageAsset: 'lib/assets/images/backgorundImagePisicology.png',
      icon: Icons.psychology_outlined,
      iconBackgroundColor: const Color(0xFFEDEFFF),
      title: 'Precisa de ajuda?\nConte com nossa equipe de psicólogos.',
      description:
          'Uma mente merece cuidado profissional.\nEncontre suporte quando mais precisar.',
      actionText: 'Ver Mais',
      onPressed: onPressed,
    );
  }
}
