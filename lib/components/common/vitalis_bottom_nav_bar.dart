import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisBottomNavBar extends StatelessWidget {
  const VitalisBottomNavBar({
    super.key,
    this.onHomePressed,
    this.isHomeSelected = true,
  });

  final VoidCallback? onHomePressed;
  final bool isHomeSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.surfaceContainer, width: 1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onHomePressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isHomeSelected ? const Color(0xFFD7F6ED) : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isHomeSelected ? Colors.transparent : AppColors.surfaceContainer,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.home_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Início',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
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
