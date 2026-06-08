import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist_flutter/global_widget/app_bottom_sheet.dart';
import 'package:todolist_flutter/global_widget/search_bar.dart';

void main() {
  testWidgets('Search bar renders its hint and icons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Searchbars())),
    );

    expect(find.text('Search...'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
  });

  testWidgets('Bottom sheet shell displays its content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppBottomSheet(child: Text('Mon contenu'))),
      ),
    );

    expect(find.text('Mon contenu'), findsOneWidget);
  });
}
