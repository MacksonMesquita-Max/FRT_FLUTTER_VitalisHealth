import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/divider_with_text.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_password_field.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';
import 'package:vitalis_app/components/screens/home/home_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final email = value.trim();
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  void _handleContinue() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isValid = name.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
    if (!isValid) {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preencha todos os campos para continuar.'),
          backgroundColor: const Color(0xFFB3261E),
          behavior: SnackBarBehavior.fixed,
        ),
      );
      return;
    }

    final emailOk = _isValidEmail(email);
    final passwordOk = password.length >= 8;
    if (!emailOk || !passwordOk) {
      setState(() {
        _emailError = emailOk ? null : 'E-mail inválido. Informe um e-mail com @ e domínio.';
        _passwordError = passwordOk ? null : 'Senha deve ter pelo menos 8 caracteres.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifique os campos destacados.'),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Color(0xFFB3261E),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cadastro realizado com sucesso!'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.fixed,
      ),
    );

    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      final sessionEntryDate = DateTime.now();
      VitalisUserProfileScope.of(context).initializeSession(
        displayName: name,
        memberSince: sessionEntryDate,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Vitalis',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bem-vindo(a)',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Vamos começar sua jornada de bem-estar?',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.outline,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _FieldLabel(text: 'Como devemos te chamar?'),
                      const SizedBox(height: 8),
                      VitalisTextField(
                        hintText: 'Nome completo',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'Seu melhor e-mail'),
                      const SizedBox(height: 8),
                      VitalisTextField(
                        hintText: 'email@exemplo.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        errorText: _emailError,
                        onChanged: (value) {
                          if (_emailError == null) return;
                          if (_isValidEmail(value)) {
                            setState(() => _emailError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'Crie uma senha segura'),
                      const SizedBox(height: 8),
                      VitalisPasswordField(
                        hintText: 'Mínimo 8 caracteres',
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        errorText: _passwordError,
                        onChanged: (value) {
                          if (_passwordError == null) return;
                          if (value.length >= 8) {
                            setState(() => _passwordError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      VitalisPrimaryButton(
                        label: 'Continuar',
                        onPressed: _handleContinue,
                      ),
                      const SizedBox(height: 18),
                      const DividerWithText(text: 'ou continue com'),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já tem uma conta? ',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Entre aqui',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Ao criar uma conta, você concorda com nossos\nTermos de Uso e Privacidade.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.outline,
                          height: 1.25,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 6,
              left: 6,
              child: VitalisBackButton(),
            ),
          ],
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
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
