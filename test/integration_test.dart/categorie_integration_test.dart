import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist_flutter/global_widget/categories.dart';
import 'package:todolist_flutter/global_widget/create_category.dart';
import 'package:todolist_flutter/feature/tasks/controllers/category_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/task_controller.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import '../categories_unit_test.mocks.dart';

void main() {
  late CategoryController controller;
  late MockApiService mockApiService;
  late MockCategoryBox mockCategoryBox;
  late MockTaskController mockTaskController;

  setUp(() {
    mockApiService = MockApiService();
    mockCategoryBox = MockCategoryBox();
    mockTaskController = MockTaskController();

    Get.put<TaskController>(mockTaskController);

    controller = CategoryController(
      apiService: mockApiService,
      categoryBox: mockCategoryBox,
    );

    Get.put<CategoryController>(controller);
  });

  tearDown(() => Get.reset());

  testWidgets(
    "affiche d'aucune categorie lorsque le tableau des categories est vide",
    (WidgetTester test) async {
      when(mockCategoryBox.getAll()).thenReturn([]);
      controller.categories.clear();

      await test.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));

      expect(find.text("aucune categorie"), findsOneWidget);
    },
  );

  testWidgets("affichage lorsque les categories sont disponibles ", (
    WidgetTester test,
  ) async {
    final mockList = [
      CategoryEntity(name: "sante")..id = 1,
      CategoryEntity(name: "loisir")..id = 2,
      CategoryEntity(name: "projet")..id = 3,
    ];

    controller.categories.assignAll(mockList);

    await test.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));
    await test.pump();

    expect(find.text("sante"), findsOneWidget);
    expect(find.text("loisir"), findsOneWidget);
    expect(find.text("projet"), findsOneWidget);
    expect(find.text("Tout"), findsOneWidget);
  });

  testWidgets(
    "test de l'ouverture du bottomsheet pour creeer une nouvelle categorie",
    (WidgetTester test) async {
      await test.pumpWidget(MaterialApp(home: Scaffold(body: Categories())));

      await test.tap(find.byIcon(Icons.add_circle));
      await test.pumpAndSettle();

      expect(find.byType(CreateCategory), findsOneWidget);
    },
  );
}
