import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/home/vitalis_image_cta_card.dart';

class VitalisFriendsConnectionCard extends StatelessWidget {
  const VitalisFriendsConnectionCard({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return VitalisImageCtaCard(
      imageAsset: 'lib/assets/images/backgorundImageWinnerFriends.png',
      icon: Icons.groups_outlined,
      iconBackgroundColor: const Color(0xFFEAF9F0),
      title: 'Conecte-se com seus amigos\ne pratique disputas saudáveis!',
      description:
          'A motivação é maior quando compartilhada.\nCrie desafios e celebre vitórias juntos.',
      actionText: 'Iniciar Conexão',
      onPressed: onPressed,
    );
  }
}
