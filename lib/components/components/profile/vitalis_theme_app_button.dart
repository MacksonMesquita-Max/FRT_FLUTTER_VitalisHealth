import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisThemeAppButton extends StatefulWidget {
  const VitalisThemeAppButton({
    super.key,
    this.initialIsDarkMode = false,
    this.onChanged,
  });

  final bool initialIsDarkMode;
  final ValueChanged<bool>? onChanged;

  @override
  State<VitalisThemeAppButton> createState() => _VitalisThemeAppButtonState();
}

class _VitalisThemeAppButtonState extends State<VitalisThemeAppButton> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialIsDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentLabel = _isDarkMode ? 'Escuro' : 'Claro';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.light_mode_outlined,
            color: AppColors.outline,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tema do App',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            currentLabel,
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              widget.onChanged?.call(value);
            },
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
