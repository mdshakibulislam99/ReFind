import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refind/main.dart';

Future<void> reveal(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    150,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Onboarding reaches account screen', (tester) async {
    await tester.pumpWidget(const ReFindApp());
    await reveal(tester, find.text('Let’s get started  →'));
    await tester.tap(find.text('Let’s get started  →'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 2; i++) {
      await reveal(tester, find.text('Continue  →'));
      await tester.tap(find.text('Continue  →'));
      await tester.pumpAndSettle();
    }
    await reveal(tester, find.text('Get started'));
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('Join the good find.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Report validates required fields and returns entered item', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    Item? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await Navigator.of(context).push<Item>(
                  MaterialPageRoute(
                    builder: (_) => const ReportPage(lost: true),
                  ),
                );
              },
              child: const Text('Start'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Continue  →'));
    await tester.tap(find.text('Continue  →'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an item name'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Blue backpack');
    await reveal(tester, find.text('Continue  →'));
    await tester.tap(find.text('Continue  →'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'City library');
    await reveal(tester, find.text('Continue  →'));
    await tester.tap(find.text('Continue  →'));
    await tester.pumpAndSettle();
    expect(find.text('Blue backpack'), findsOneWidget);
    await reveal(tester, find.text('Publish report'));
    await tester.tap(find.text('Publish report'));
    await tester.pumpAndSettle();
    expect(result?.name, 'Blue backpack');
    expect(result?.place, 'City library');
    expect(result?.lost, isTrue);
    expect(result?.mine, isTrue);
  });

  testWidgets('Home filters items and shows empty reports state', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));
    await tester.enterText(find.byType(TextField), 'no matching item');
    await tester.pumpAndSettle();
    await reveal(tester, find.text('No reports here yet.'));
    expect(find.text('No reports here yet.'), findsOneWidget);
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Your reports'), findsOneWidget);
    await reveal(tester, find.text('No reports here yet.'));
    expect(find.text('No reports here yet.'), findsOneWidget);
  });
}
