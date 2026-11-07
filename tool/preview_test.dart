import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refind/main.dart';

void main() {
  testWidgets('Capture phone screen previews', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const fontPath = String.fromEnvironment('PREVIEW_FONT');
    if (fontPath.isNotEmpty) {
      final bytes = File(fontPath).readAsBytesSync();
      final loader = FontLoader('Roboto')
        ..addFont(Future.value(ByteData.sublistView(bytes)));
      await loader.load();
    }
    final icons = FontLoader('MaterialIcons')..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    final app = const ReFindApp();
    await tester.pumpWidget(app);
    final theme = tester.widget<MaterialApp>(find.byType(MaterialApp)).theme;
    for (final entry in <String, Widget>{
      'welcome': const Welcome(),
      'home': const Home(),
      'report': const ReportPage(lost: true),
      'matching': const MatchingPage(),
    }.entries) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: RepaintBoundary(
            key: const ValueKey('preview'),
            child: entry.value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('preview')),
        matchesGoldenFile('../docs/previews/${entry.key}.png'),
      );
    }
  });
}
