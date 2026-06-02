import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';
import 'package:vitalis_app/components/common/vitalis_back_button.dart';
import 'package:vitalis_app/components/common/vitalis_primary_button.dart';

class PremiumTermsScreen extends StatelessWidget {
  const PremiumTermsScreen({
    super.key,
    this.showConsentActions = false,
  });

  final bool showConsentActions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: showConsentActions ? const _ConsentActions() : null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  const VitalisBackButton(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Política e Termos',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.surfaceContainer, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Política de Privacidade e Termos de Assinatura – Planos Premium',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'A sua privacidade e a transparência no uso dos nossos serviços são prioridades para nós. Esta Política de Privacidade explica como coletamos, usamos e protegemos seus dados, além de detalhar as regras de cobrança e cancelamento dos nossos Planos Premium.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.outline,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(text: '1. Coleta e Uso de Dados'),
                          const SizedBox(height: 8),
                          _BodyText(
                            text:
                                'Para processar a sua assinatura e garantir o acesso aos recursos Premium, coletamos informações essenciais, tais como:',
                          ),
                          const SizedBox(height: 10),
                          const _Bullet(text: 'Dados de Cadastro: Nome, e-mail e informações de conta.'),
                          const SizedBox(height: 6),
                          const _Bullet(
                            text:
                                'Dados de Pagamento: Os pagamentos são processados por parceiros seguros e criptografados. Nós não armazenamos os dados completos do seu cartão de crédito em nossos servidores.',
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(text: '2. Funcionamento dos Planos Premium'),
                          const SizedBox(height: 8),
                          _BodyText(
                            text:
                                'Oferecemos duas modalidades de assinatura para o Plano Premium. Ao contratar, você concorda com as seguintes condições de faturamento:',
                          ),
                          const SizedBox(height: 10),
                          const _Bullet(
                            text:
                                'Plano Mensal: O valor da assinatura é debitado automaticamente todos os meses (recorrência mensal), diretamente na forma de pagamento escolhida, até que você solicite o cancelamento.',
                          ),
                          const SizedBox(height: 6),
                          const _Bullet(
                            text:
                                'Plano Anual: O valor é debitado uma única vez por ano. Esta modalidade oferece um desconto de 6% em relação ao valor proporcional acumulado do plano mensal. A renovação ocorre automaticamente a cada 12 meses, a menos que seja cancelada.',
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(text: '3. Política de Cancelamento Flexível'),
                          const SizedBox(height: 8),
                          _BodyText(
                            text:
                                'Acreditamos na total liberdade dos nossos usuários. Por isso, você pode cancelar qualquer um dos planos quando quiser.',
                          ),
                          const SizedBox(height: 10),
                          const _Bullet(
                            text:
                                'Como funciona o cancelamento: Ao cancelar, você continuará tendo acesso aos recursos do Plano Premium até o final do período já pago (seja o restante do mês ou do ano vigente).',
                          ),
                          const SizedBox(height: 6),
                          const _Bullet(
                            text:
                                'Sem taxas ocultas: Não há aplicação de multas ou taxas de fidelidade pelo cancelamento. Após o término do período pago, nenhuma nova cobrança será realizada e sua conta retornará à versão gratuita.',
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(text: '4. Segurança dos Dados'),
                          const SizedBox(height: 8),
                          _BodyText(
                            text:
                                'Implementamos medidas de segurança técnicas e organizacionais para proteger seus dados pessoais contra acessos não autorizados, perda ou alteração. Seus dados de navegação e uso da plataforma são utilizados exclusivamente para melhorar a sua experiência técnica.',
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(text: '5. Alterações nesta Política'),
                          const SizedBox(height: 8),
                          _BodyText(
                            text:
                                'Reservamo-nos o direito de atualizar este documento periodicamente. Sempre que houver alterações significativas na forma de cobrança ou no uso dos seus dados, você será notificado por e-mail ou por meio de um aviso em nossa plataforma.',
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(text: 'Consentimento'),
                          const SizedBox(height: 8),
                          _BodyText(
                            text:
                                'Ao assinar o Plano Premium (Mensal ou Anual), você declara estar ciente e de acordo com os termos de cobrança, desconto e cancelamento descritos nesta política.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentActions extends StatelessWidget {
  const _ConsentActions();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitalisPrimaryButton(
              label: 'Concordo com os termos de aquisição',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  side: const BorderSide(color: AppColors.outlineVariant, width: 1.2),
                  foregroundColor: AppColors.onSurface,
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('NÃO concordo com os termos de aquisição'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.outline,
            height: 1.35,
          ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.outline,
          height: 1.35,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: SizedBox(
            width: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: 6, height: 6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}
