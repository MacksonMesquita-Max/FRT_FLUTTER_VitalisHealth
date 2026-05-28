import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisTextField extends StatelessWidget {
  const VitalisTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.outlineVariant,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.outlineVariant,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.85),
              width: 1.5,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

