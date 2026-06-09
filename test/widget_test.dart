import "package:flutter_test/flutter_test.dart";

import "package:amber_calendar/main.dart";

void main() {
  testWidgets("Counter increments smoke test", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Amber());

    expect(find.text("Salut !"), findsOneWidget);
  });
}
