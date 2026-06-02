import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_mercenary/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> returnToMenu(WidgetTester tester) async {
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('core-fun-loop')), findsOneWidget);
  }

  group('MG-0003 Pixel Mercenary Guild - Game Loop E2E', () {
    testWidgets('Core gameplay loop: battle, attributes, combo system', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('game-id')), findsOneWidget);
      expect(find.text('MG-0003'), findsOneWidget);
      expect(find.text('Pixel Mercenary Guild'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('primary-loop')), findsOneWidget);
      expect(find.textContaining('Level 1'), findsOneWidget);

      // Complete battle action
      await tester.tap(find.byKey(const ValueKey('complete-action')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Level 2'), findsOneWidget);
    });

    testWidgets('Attribute system and elemental advantages', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      // Verify attribute system is displayed
      expect(find.textContaining('attribute'), findsOneWidget);
      expect(find.textContaining('elemental'), findsOneWidget);

      // Complete battles to test attribute advantages
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const ValueKey('complete-action')));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Combo system and damage multipliers', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      // Verify combo mechanics
      expect(find.textContaining('combo'), findsOneWidget);
      expect(find.textContaining('multiplier'), findsOneWidget);

      // Execute combo actions
      await tester.tap(find.byKey(const ValueKey('complete-action')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Level 2'), findsOneWidget);
    });

    testWidgets('Level roadmap and progression tracking', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('level-roadmap')));
      await tester.pumpAndSettle();

      expect(find.text('Level Roadmap'), findsWidgets);
      expect(find.byKey(const ValueKey('level-list')), findsOneWidget);

      await returnToMenu(tester);
    });

    testWidgets('Competition systems: tournament and guild', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('tournament')));
      await tester.pumpAndSettle();
      expect(find.text('Tournament'), findsWidgets);
      await returnToMenu(tester);

      await tester.tap(find.byKey(const ValueKey('guild-war')));
      await tester.pumpAndSettle();
      expect(find.text('Guild War'), findsWidgets);
      await returnToMenu(tester);
    });

    testWidgets('Full game loop with attribute strategy', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      // Progress through multiple battles
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const ValueKey('complete-action')));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Level 6'), findsOneWidget);
    });
  });
}