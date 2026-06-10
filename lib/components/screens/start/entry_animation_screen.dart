import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vitalis_app/components/screens/start/start_screen.dart';

class EntryAnimationScreen extends StatefulWidget {
  const EntryAnimationScreen({super.key});

  @override
  State<EntryAnimationScreen> createState() => _EntryAnimationScreenState();
}

class _EntryAnimationScreenState extends State<EntryAnimationScreen>
    with SingleTickerProviderStateMixin {
  static const _backgroundColor = Color(0xFF22292F);
  static const _animationAsset =
      'lib/assets/animations/fb2fc25e-1171-11ee-a8aa-7f6b716e0d2c.json';

  late final AnimationController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _openStartScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openStartScreen() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const StartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Vitalis',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Lottie.asset(
                    _animationAsset,
                    controller: _controller,
                    fit: BoxFit.contain,
                    repeat: false,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
