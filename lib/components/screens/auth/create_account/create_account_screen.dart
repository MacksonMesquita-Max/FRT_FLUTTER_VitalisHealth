import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/divider_with_text.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_password_field.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';
import 'package:vitalis_app/components/common/vitalis_text_field.dart';
import 'package:vitalis_app/components/common/vitalis_user_profile_controller.dart';
import 'package:vitalis_app/components/screens/home/home_screen.dart';
import 'package:vitalis_app/services/api_client.dart';
import 'package:vitalis_app/services/firebase_auth_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  String? _emailError;
  String? _passwordError;
  bool _isSubmitting = false;
  String? _connectionStatus;
  ApiCallResult? _authMeResult;
  ApiCallResult? _usersMeResult;

  late final ApiClient _apiClient = ApiClient(authService: _authService);

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

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login com Google em configuracao.'),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _handleGuestLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login como convidado em configuracao.'),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB3261E),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  bool _validateForm({required bool requireName}) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isValid =
        email.isNotEmpty && password.isNotEmpty && (!requireName || name.isNotEmpty);
    if (!isValid) {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });
      _showErrorSnackBar(
        requireName
            ? 'Preencha nome, e-mail e senha para continuar.'
            : 'Preencha e-mail e senha para entrar.',
      );
      return false;
    }

    final emailOk = _isValidEmail(email);
    final passwordOk = password.length >= 8;
    if (!emailOk || !passwordOk) {
      setState(() {
        _emailError = emailOk ? null : 'E-mail inválido. Informe um e-mail com @ e domínio.';
        _passwordError = passwordOk ? null : 'Senha deve ter pelo menos 8 caracteres.';
      });
      _showErrorSnackBar('Verifique os campos destacados.');
      return false;
    }
    return true;
  }

  String _firebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Esse e-mail já está em uso. Toque em "Entre aqui" para acessar.';
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 8 caracteres.';
      case 'user-not-found':
      case 'invalid-credential':
        return 'E-mail ou senha inválidos.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'network-request-failed':
        return 'Falha de rede. Verifique a conexão do app com a internet e a API.';
      default:
        return error.message ?? 'Não foi possível autenticar agora.';
    }
  }

  String _formatResultBody(Object? body) {
    if (body == null) {
      return 'Sem conteúdo';
    }

    if (body is String) {
      return body;
    }

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(body);
  }

  Future<void> _authenticateAndConnect({required bool createAccount}) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_validateForm(requireName: createAccount)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _connectionStatus = null;
      _authMeResult = null;
      _usersMeResult = null;
    });

    try {
      if (createAccount) {
        await _authService.registerWithEmailAndPassword(
          email: email,
          password: password,
          displayName: name,
        );
      } else {
        await _authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final authMeResult = await _apiClient.getAuthMe();
      final usersMeResult = await _apiClient.getUsersMe();

      if (!mounted) return;

      setState(() {
        _authMeResult = authMeResult;
        _usersMeResult = usersMeResult;
        _connectionStatus =
            'GET /api/auth/me -> ${authMeResult.statusCode} | '
            'GET /api/users/me -> ${usersMeResult.statusCode}';
      });

      if (!authMeResult.isSuccess || !usersMeResult.isSuccess) {
        _showErrorSnackBar(
          'Autenticação ok, mas a API respondeu com erro. Veja os detalhes abaixo.',
        );
        return;
      }

      final displayName = _authService.currentUser?.displayName;
      final resolvedName =
          (displayName != null && displayName.trim().isNotEmpty)
          ? displayName.trim()
          : (name.isNotEmpty ? name : email.split('@').first);

      VitalisUserProfileScope.of(context).initializeSession(
        displayName: resolvedName,
        memberSince: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            createAccount
                ? 'Conta criada e conectada ao backend com sucesso!'
                : 'Login realizado e backend validado com sucesso!',
          ),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.fixed,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(_firebaseErrorMessage(error));
    } on StateError catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(error.message);
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(
        'Falha ao conectar com o backend. Confira a URL da API e o servidor na porta 3333.\n$error',
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _handleContinue() {
    return _authenticateAndConnect(createAccount: true);
  }

  Future<void> _handleSignIn() {
    return _authenticateAndConnect(createAccount: false);
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
                padding: const EdgeInsets.fromLTRB(22, 15, 22, 22),
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
                        label: _isSubmitting ? 'Conectando...' : 'Continuar',
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                _handleContinue();
                              },
                      ),
                      if (_connectionStatus != null ||
                          _authMeResult != null ||
                          _usersMeResult != null) ...[
                        const SizedBox(height: 16),
                        _ConnectionStatusCard(
                          status: _connectionStatus,
                          authMeResult: _authMeResult,
                          usersMeResult: _usersMeResult,
                          formatBody: _formatResultBody,
                        ),
                      ],
                      const SizedBox(height: 18),
                      const DividerWithText(text: 'ou continue com'),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _SocialAuthButton(
                              label: 'Google',
                              icon: SvgPicture.asset(
                                'lib/assets/images/google_icon.svg',
                                width: 18,
                                height: 18,
                              ),
                              onPressed: _handleGoogleLogin,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SocialAuthButton(
                              label: 'Convidado',
                              icon: const Icon(
                                Icons.person_pin,
                                color: AppColors.secondary,
                                size: 22,
                              ),
                              onPressed: _handleGuestLogin,
                            ),
                          ),
                        ],
                      ),
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
                            onTap: _isSubmitting
                                ? null
                                : () {
                                    _handleSignIn();
                                  },
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

class _ConnectionStatusCard extends StatelessWidget {
  const _ConnectionStatusCard({
    required this.status,
    required this.authMeResult,
    required this.usersMeResult,
    required this.formatBody,
  });

  final String? status;
  final ApiCallResult? authMeResult;
  final ApiCallResult? usersMeResult;
  final String Function(Object? body) formatBody;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget endpointBlock(String title, ApiCallResult? result) {
      if (result == null) {
        return const SizedBox.shrink();
      }

      final body = formatBody(result.body);
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title: ${result.statusCode}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: result.isSuccess ? AppColors.secondary : const Color(0xFFB3261E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.outline,
                height: 1.3,
              ),
            ),
          ],
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status da conexão',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (status != null) ...[
              const SizedBox(height: 6),
              Text(
                status!,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                  height: 1.3,
                ),
              ),
            ],
            endpointBlock('GET /api/auth/me', authMeResult),
            endpointBlock('GET /api/users/me', usersMeResult),
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

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
