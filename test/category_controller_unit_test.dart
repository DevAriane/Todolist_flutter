import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'package:todolist_flutter/feature/tasks/controllers/category_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/task_controller.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'category_controller_unit_test.mocks.dart';

@GenerateMocks(
  [ApiService, TaskController],
  customMocks: [MockSpec<Box<CategoryEntity>>(as: #MockCategoryBox)],
)
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
  });
  tearDown() {
    Get.reset();
  }

  group("test du chargement des categories depuis l'api", () {
    test("loading API", () {
      final localCategories = [
        CategoryEntity(name: "Sport"),
        CategoryEntity(name: "Sante"),
      ];

      when(mockCategoryBox.getAll());
    });
  });

  group("ajout d'une category ", () {
    test("ajout d'une category", () {
      final newCategory = CategoryEntity(name: 'LOISIR');
      when(mockCategoryBox.put(newCategory));
    });
  });
}
