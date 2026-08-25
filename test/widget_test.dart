// ignore_for_file: depend_on_referenced_packages

// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:super_app/main.dart';

void main() {
  testWidgets(
    'App structural smoke test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const SuperApp(),
      );

      await tester.pump();

      expect(
        find.byType(SuperApp),
        findsOneWidget,
      );
    },
  );
}