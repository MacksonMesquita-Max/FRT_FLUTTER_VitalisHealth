import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  const FrostedGlass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blurSigmaX = 18,
    this.blurSigmaY = 18,
    this.backgroundColor = const Color(0x66FFFFFF),
    this.borderColor = const Color(0x33FFFFFF),
    this.borderWidth = 1,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigmaX;
  final double blurSigmaY;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );
  }
}

