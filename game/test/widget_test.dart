import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_mercenary/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    setupDependencies();
    await tester.pumpWidget(const PixelMercenaryApp());

    // Verify that our app finds the text.
    expect(find.text('Squad'), findsOneWidget);
  });
}
