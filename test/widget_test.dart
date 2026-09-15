import 'package:flutter_test/flutter_test.dart';
import 'package:zalyx/zalyx_app.dart';

void main() {
  testWidgets('ZalyxWaterApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZalyxWaterApp());
    expect(find.byType(ZalyxWaterApp), findsOneWidget);
  });
}