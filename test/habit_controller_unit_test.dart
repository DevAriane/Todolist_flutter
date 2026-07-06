import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'package:todolist_flutter/controller/category_habit_controller.dart';
import 'package:todolist_flutter/controller/habit_controller.dart';
import 'package:todolist_flutter/models/category_habit_entity.dart';
import 'habit_controller_unit_test.mocks.dart';

@GenerateMocks(
  [ApiService, HabitController],
  customMocks: [MockSpec<Box<CategoryHabitEntity>>(as: #MockCategoryHabitBox)],
)
void main() {
  late CategoryHabitController mockCategoryHabitController;
  late ApiService mockApiService;
  late MockCategoryHabitBox mockCategoryHabitBox;
  late HabitController mockHabitController;

  setUp(() {
    mockApiService = MockApiService();
    mockHabitController = MockHabitController();
    mockCategoryHabitBox = MockCategoryHabitBox();

    Get.put<HabitController>(MockHabitController());
  });

  tearDown(() => Get.reset());

  group("chargenment des categories depuis l'API", () {
    test("chargement des categories d'habitudes depuis l'API", () {
      final loadCategoryHabit = [
        CategoryHabitEntity(name: 'projet'),
        CategoryHabitEntity(name: "jeux"),
        CategoryHabitEntity(name: "loisir"),
      ];

      when(mockCategoryHabitBox.getAll());
    });
  });

  group("ajout d'une categorie d'habitute", () {
    test("ajout d'une nouvelle category", () {
      final newCategoryHabit = CategoryHabitEntity(name: "play");
      when(mockCategoryHabitBox.put(newCategoryHabit));
    });
  });
}
