import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/controller/category_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';
import 'package:todolist_flutter/controller/person_controller.dart';
import 'package:todolist_flutter/global_widget/categories.dart';
import 'package:todolist_flutter/global_widget/create_category.dart';
import 'package:todolist_flutter/models/category_entity.dart';

class MockPersonController extends PersonController {
  @override
  void onReady() {}
}

class MockCategoryController extends CategoryController {
  @override
  void onReady() {}
}

class MockTaskController extends TaskController {
  bool applyFiltersCalled = false;

  @override
  void onReady() {}

  @override
  void applyFilters() {
    applyFiltersCalled = true;
  }
}

void main() {
  late MockCategoryController mockCategoryController;
  late MockTaskController mockTaskController;
  late MockPersonController mockPersonController;

  setUp(() {
    Get.reset();

    mockCategoryController = MockCategoryController();
    mockPersonController = MockPersonController();

    Get.put<CategoryController>(mockCategoryController);
    Get.put<PersonController>(mockPersonController);

    mockTaskController = MockTaskController();
    Get.put<TaskController>(mockTaskController);
  });

  testWidgets('Affiche "Aucune catégorie" quand la liste est vide', (
    WidgetTester tester,
  ) async {
    mockCategoryController.categories.clear();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));

    expect(find.text('Catégories'), findsOneWidget);
    expect(find.text('Aucune catégorie'), findsOneWidget);
    expect(find.text('Tout '), findsNothing);
  });

  testWidgets(
    'Affiche la liste des catégories quand elle contient des éléments',
    (WidgetTester tester) async {
      final cat1 = CategoryEntity(name: 'Travail')..id = 1;
      final cat2 = CategoryEntity(name: 'Perso')..id = 2;
      mockCategoryController.categories.addAll([cat1, cat2]);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));
      await tester.pump();

      expect(find.text('Aucune catégorie'), findsNothing);
      expect(find.text('Tout '), findsOneWidget);
      expect(find.text('Travail'), findsOneWidget);
      expect(find.text('Perso'), findsOneWidget);
    },
  );

  testWidgets(
    'Sélectionne une catégorie et notifie TaskController lors du clic',
    (WidgetTester tester) async {
      final catSport = CategoryEntity(name: 'Sport')..id = 99;
      mockCategoryController.categories.add(catSport);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));
      await tester.pump();

      await tester.tap(find.text('Sport'));
      await tester.pump();

      expect(mockCategoryController.selectedCategoryId.value, equals(99));
      expect(mockTaskController.applyFiltersCalled, isTrue);
    },
  );

  testWidgets('Ouvre la bottom sheet CreateCategory au clic sur le bouton +', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));

    final addButton = find.byIcon(Icons.add_circle);
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.byType(CreateCategory), findsOneWidget);
  });
}
