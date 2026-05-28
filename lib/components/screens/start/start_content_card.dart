import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/frosted_glass.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class StartContentCard extends StatelessWidget {
  const StartContentCard({
    super.key,
    required this.onStart,
  });

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FrostedGlass(
      backgroundColor: const Color.fromARGB(32, 255, 255, 255),
      borderColor: const Color(0x26FFFFFF),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Encontre seu\nequilíbrio.',
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                height: 1.05,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Respire fundo. Deixe o barulho lá\nfora e foque no que importa: você.\nSua jornada começa agora.',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            VitalisPrimaryButton(
              label: 'Começar Jornada',
              trailing: const Icon(Icons.arrow_forward, size: 18),
              onPressed: onStart,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 6),
                Text(
                  'Menos de 2 minutos para começar',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '“Você não precisa ser perfeito, apenas precisa\ncomeçar.”',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.65),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
