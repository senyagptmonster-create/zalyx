import 'package:flutter_test/flutter_test.dart';
import 'package:zalyx/main.dart';

void main() {
  testWidgets('ZalyxApp hydration smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZalyxApp());
    expect(find.text('ZALYX HYDRATION'), findsOneWidget);
    expect(find.text('Quick Intake Log'), findsOneWidget);
  });
}
