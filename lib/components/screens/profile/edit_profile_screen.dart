import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vitalis_app/components/components/home/vitalis_user_avatar.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController(text: '***.***.432-09');
  final _cepController = TextEditingController(text: '01310-200');
  final _phoneController = TextEditingController(text: '(11)98765-4321');
  final _emailController =
      TextEditingController(text: 'ricardo.silveira@exemplo.com.br');
  final _aboutController = TextEditingController(
    text: 'Conte-nos um pouco sobre sua jornada de saúde...',
  );

  String _selectedGender = 'Masculino';
  DateTime _birthDate = DateTime(1992, 4, 15);
  bool _twoFactorEnabled = true;
  String? _avatarImagePath;
  String? _nameError;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final profileController = VitalisUserProfileScope.of(context);
    _nameController.text = profileController.displayName;
    _avatarImagePath = profileController.avatarImagePath;
    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _cepController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (!mounted || file == null) return;

    setState(() {
      _avatarImagePath = file.path;
    });
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (!mounted || picked == null) return;

    setState(() {
      _birthDate = picked;
    });
  }

  void _save() {
    final displayName = _nameController.text.trim();
    setState(() {
      _nameError = displayName.isEmpty ? 'Informe o nome do usuario.' : null;
    });
    if (_nameError != null) return;

    VitalisUserProfileScope.of(context).updateProfile(
      displayName: displayName,
      avatarImagePath: _avatarImagePath,
    );
    Navigator.of(context).pop(true);
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$month/$day/${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 8),
                  Text(
                    'Editar Perfil',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        VitalisUserAvatar(
                          size: 92,
                          imagePathOverride: _avatarImagePath,
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: InkWell(
                            onTap: _pickProfileImage,
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _pickProfileImage,
                      child: Text(
                        'Alterar foto de perfil',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _FieldLabel(text: 'Nome'),
              const SizedBox(height: 8),
              VitalisTextField(
                hintText: 'Nome completo',
                controller: _nameController,
                errorText: _nameError,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _FieldLabel(text: 'CPF'),
              const SizedBox(height: 8),
              VitalisTextField(
                hintText: 'CPF',
                controller: _cpfController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _FieldLabel(text: 'CEP'),
              const SizedBox(height: 8),
              VitalisTextField(
                hintText: 'CEP',
                controller: _cepController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _FieldLabel(text: 'Telefone'),
              const SizedBox(height: 8),
              VitalisTextField(
                hintText: 'Telefone',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _FieldLabel(text: 'Email cadastrado'),
              const SizedBox(height: 8),
              VitalisTextField(
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.outline,
                  size: 20,
                ),
              ),
              const SizedBox(height: 14),
              _FieldLabel(text: 'Sexo'),
              const SizedBox(height: 8),
              _DropdownField<String>(
                value: _selectedGender,
                items: const ['Masculino', 'Feminino', 'Outro', 'Prefiro não informar'],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedGender = value);
                },
              ),
              const SizedBox(height: 14),
              _FieldLabel(text: 'Data de Nascimento'),
              const SizedBox(height: 8),
              _DatePickerField(
                value: _formatDate(_birthDate),
                onTap: _pickBirthDate,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: _FieldLabel(text: 'Sobre você'),
                  ),
                  Text(
                    '${_aboutController.text.length}/150 caracteres',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              VitalisTextField(
                hintText: 'Conte um pouco sobre sua jornada de saude...',
                controller: _aboutController,
                maxLines: 4,
                minLines: 4,
                textInputAction: TextInputAction.newline,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 22),
              Text(
                'Segurança',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _SettingsCard(
                children: [
                  _ToggleSettingTile(
                    icon: Icons.verified_user_outlined,
                    iconBackgroundColor: const Color(0xFFE4F4E8),
                    title: 'Autenticação de dois fatores',
                    subtitle: 'Mais proteção para sua conta',
                    value: _twoFactorEnabled,
                    onChanged: (value) => setState(() => _twoFactorEnabled = value),
                  ),
                  _NavigationSettingTile(
                    icon: Icons.lock_reset_outlined,
                    iconBackgroundColor: const Color(0xFFF1F2F2),
                    title: 'Alteração de senha',
                    subtitle: 'Ultima alteração há 3 meses',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Alteração de senha em breve.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              VitalisPrimaryButton(
                label: 'Salvar Alterações',
                trailing: const Icon(Icons.save_outlined, size: 18),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
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
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.value,
    required this.onTap,
  });

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.outlineVariant,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
              ),
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
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

class _NavigationSettingTile extends StatelessWidget {
  const _NavigationSettingTile({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
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
              const Icon(
                Icons.chevron_right,
                color: AppColors.onSurface,
              ),
            ],
          ),
        ),
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
