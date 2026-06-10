import 'package:flutter/material.dart';
import 'package:vitalis_app/components/components/start/start_content_card.dart';
import 'package:vitalis_app/components/screens/auth/create_account/create_account_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
    this.onStart,
    this.backgroundImage,
  });

  final VoidCallback? onStart;
  final ImageProvider<Object>? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final image = backgroundImage ??
        const AssetImage('lib/assets/images/backgroundHomepage.png');
    final handleStart = onStart ??
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateAccountScreen(),
            ),
          );
        };

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                1.05, 0.00, 0.00, 0, 0,
                0.00, 1.05, 0.00, 0, 0,
                0.00, 0.00, 1.05, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.40),
                    Colors.black.withValues(alpha: 0.50),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Vitalis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const Spacer(),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: StartContentCard(onStart: handleStart),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
