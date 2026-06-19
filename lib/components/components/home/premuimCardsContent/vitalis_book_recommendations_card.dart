import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/home/vitalis_image_cta_card.dart';

class VitalisBookRecommendationsCard extends StatelessWidget {
  const VitalisBookRecommendationsCard({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return VitalisImageCtaCard(
      imageAsset: 'lib/assets/images/backgorundImageLibrary.png',
      icon: Icons.menu_book_outlined,
      iconBackgroundColor: const Color(0xFFEAF2FF),
      title: 'Sem boas leituras?\nConfira nossa lista de livros!',
      description:
          'Expanda seus horizontes com curadorias\nfocadas em desenvolvimento pessoal.',
      actionText: 'Ver Mais',
      onPressed: onPressed,
    );
  }
}
