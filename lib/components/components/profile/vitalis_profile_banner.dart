import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisProfileBanner extends StatelessWidget {
  const VitalisProfileBanner({
    super.key,
    required this.height,
    this.assetPath,
    this.filePath,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  final double height;
  final String? assetPath;
  final String? filePath;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final hasFileImage = filePath != null && filePath!.isNotEmpty;
    final hasAssetImage = assetPath != null && assetPath!.isNotEmpty;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: borderRadius,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasFileImage)
              Image.file(
                File(filePath!),
                fit: BoxFit.cover,
              )
            else if (hasAssetImage)
              Image.asset(
                assetPath!,
                fit: BoxFit.cover,
              )
            else
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFCFEFE4),
                      Color(0xFFEAF7F1),
                    ],
                  ),
                ),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x14000000),
                    Color(0x1E000000),
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
