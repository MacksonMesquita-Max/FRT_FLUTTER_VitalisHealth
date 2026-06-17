import 'package:flutter/material.dart';

class VitalisLogoutAccountButton extends StatelessWidget {
  const VitalisLogoutAccountButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.logout, size: 20),
      label: const Text('Sair da conta'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFD63A33),
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(
          color: Color(0xFFF0C8C5),
          width: 1.2,
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
