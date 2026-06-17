import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisAppPermissionsCard extends StatefulWidget {
  const VitalisAppPermissionsCard({super.key});

  @override
  State<VitalisAppPermissionsCard> createState() =>
      _VitalisAppPermissionsCardState();
}

class _VitalisAppPermissionsCardState extends State<VitalisAppPermissionsCard> {
  bool _contactsPermission = false;
  bool _phonePermission = false;
  bool _galleryPermission = true;
  bool _cameraPermission = false;
  bool _notificationsPermission = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Permissões do app',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _ToggleSettingTile(
              icon: Icons.contacts_outlined,
              iconBackgroundColor: const Color(0xFFEAF2FF),
              title: 'Acesso aos contatos',
              subtitle: 'Usado para conexões e convites',
              value: _contactsPermission,
              onChanged: (value) => setState(() => _contactsPermission = value),
            ),
            _ToggleSettingTile(
              icon: Icons.call_outlined,
              iconBackgroundColor: const Color(0xFFFFF1E6),
              title: 'Chamadas telefonicas',
              subtitle: 'Usado para recursos de suporte rápido',
              value: _phonePermission,
              onChanged: (value) => setState(() => _phonePermission = value),
            ),
            _ToggleSettingTile(
              icon: Icons.photo_library_outlined,
              iconBackgroundColor: const Color(0xFFEDEFFF),
              title: 'Galeria do celular',
              subtitle: 'Usado para selecionar foto de perfil',
              value: _galleryPermission,
              onChanged: (value) => setState(() => _galleryPermission = value),
            ),
            _ToggleSettingTile(
              icon: Icons.camera_alt_outlined,
              iconBackgroundColor: const Color(0xFFEAF9F0),
              title: 'Câmera',
              subtitle: 'Usado para capturar foto de perfil',
              value: _cameraPermission,
              onChanged: (value) => setState(() => _cameraPermission = value),
            ),
            _ToggleSettingTile(
              icon: Icons.notifications_outlined,
              iconBackgroundColor: const Color(0xFFFFF6E8),
              title: 'Notificções',
              subtitle: 'Usado para lembretes e atualizções',
              value: _notificationsPermission,
              onChanged: (value) =>
                  setState(() => _notificationsPermission = value),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.surfaceContainer, width: 1),
        ),
        child: Column(children: children),
      ),
    );
  }
}

class _ToggleSettingTile extends StatelessWidget {
  const _ToggleSettingTile({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        children: [
          _SettingIcon(icon: icon, backgroundColor: iconBackgroundColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.outline,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({
    required this.icon,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 18,
        color: AppColors.primary,
      ),
    );
  }
}
