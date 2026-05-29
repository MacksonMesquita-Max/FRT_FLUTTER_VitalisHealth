// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitalis_app/main.dart';

void main() {
  testWidgets('Fluxo inicial: start -> cadastro -> home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Vitalis'), findsOneWidget);
    expect(find.text('Começar Jornada'), findsOneWidget);

    await tester.tap(find.text('Começar Jornada'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo(a)'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(find.text('Preencha todos os campos para continuar.'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ana Paula');
    await tester.enterText(fields.at(1), 'ana@exemplo.com');
    await tester.enterText(fields.at(2), '12345678');

    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Olá, Ana Paula'), findsOneWidget);
  });
}
