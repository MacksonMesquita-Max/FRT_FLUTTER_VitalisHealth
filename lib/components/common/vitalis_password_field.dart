import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';

class VitalisPasswordField extends StatefulWidget {
  const VitalisPasswordField({
    super.key,
    required this.hintText,
    this.controller,
    this.textInputAction,
    this.onChanged,
    this.errorText,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  State<VitalisPasswordField> createState() => _VitalisPasswordFieldState();
}

class _VitalisPasswordFieldState extends State<VitalisPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return VitalisTextField(
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility,
          color: AppColors.outline,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
    );
  }
}

