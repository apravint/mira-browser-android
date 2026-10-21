import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mira_browser/main.dart';

void main() {
  testWidgets('Mira Browser smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MiraBrowserApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify brand header
    expect(find.text('MIRA BROWSER'), findsOneWidget);

    // Verify speed dial items
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('DuckDuckGo'), findsOneWidget);

    // Verify Omnibox input
    expect(find.byType(TextField), findsOneWidget);

    // Verify AI trigger button
    expect(find.text('AI'), findsOneWidget);

    // Open AI Drawer
    await tester.tap(find.text('AI'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('MIRA AI ASSISTANT'), findsOneWidget);

    // Close AI drawer
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Open Tab Switcher (tapping the tab counter badge '1')
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('TABS (1)'), findsOneWidget);

    // Reset physical size
    addTearDown(tester.view.resetPhysicalSize);
  });
}
