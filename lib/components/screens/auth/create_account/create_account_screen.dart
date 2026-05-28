import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/divider_with_text.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_password_field.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
                      const VitalisTextField(
                        hintText: 'Nome completo',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'Seu melhor e-mail'),
                      const SizedBox(height: 8),
                      const VitalisTextField(
                        hintText: 'email@exemplo.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'Crie uma senha segura'),
                      const SizedBox(height: 8),
                      const VitalisPasswordField(
                        hintText: 'Mínimo 8 caracteres',
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 18),
                      VitalisPrimaryButton(
                        label: 'Criar Conta',
                        onPressed: () {},
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
