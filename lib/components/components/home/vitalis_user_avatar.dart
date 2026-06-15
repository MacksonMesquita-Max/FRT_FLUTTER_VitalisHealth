import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';

class VitalisUserAvatar extends StatelessWidget {
  const VitalisUserAvatar({
    super.key,
    this.size = 36,
    this.onPressed,
    this.imagePathOverride,
  });

  final double size;
  final VoidCallback? onPressed;
  final String? imagePathOverride;

  @override
  Widget build(BuildContext context) {
    final profileController = VitalisUserProfileScope.of(context);
    final imagePath = imagePathOverride ?? profileController.avatarImagePath;

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: imagePath == null
          ? Icon(
              Icons.person_outline,
              size: size * 0.55,
              color: AppColors.outline,
            )
          : ClipOval(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
    );

    if (onPressed == null) return avatar;

    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }
}
