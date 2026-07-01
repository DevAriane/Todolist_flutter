import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/controller/category_controller.dart';
import 'package:todolist_flutter/controller/person_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';
import 'package:todolist_flutter/models/task_entity.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'package:todolist_flutter/models/person_entity.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'package:todolist_flutter/services/objectbox_service.dart';
import 'category_controller_unit_test.mocks.dart';
import './task_controller_unit_test.mocks.dart' hide MockCategoryBox;

@GenerateMocks(
  [ApiService, TaskController],
  customMocks: [
    MockSpec<CategoryController>(),
    MockSpec<PersonController>(),
    MockSpec<Box<TaskEntity>>(as: #MockTaskBox),
    MockSpec<Box<CategoryEntity>>(as: #MockCategoryBox),
    MockSpec<Box<PersonEntity>>(as: #MockPersonBox),
  ],
)
void main() {
  late TaskController taskController;
  late MockCategoryController mockCategoryController;
  late MockPersonController mockPersonController;
  late MockTaskBox mockTaskBox;
  late MockCategoryBox mockCategoryBox;
  late MockPersonBox mockPersonBox;

  setUp(() {
    mockCategoryController = MockCategoryController();
    mockPersonController = MockPersonController();
    mockTaskBox = MockTaskBox();
    mockCategoryBox = MockCategoryBox();
    mockPersonBox = MockPersonBox();

    Get.put<CategoryController>(mockCategoryController);
    Get.put<PersonController>(mockPersonController);

    ObjectBoxService.taskBox = mockTaskBox;
    ObjectBoxService.categoryBox = mockCategoryBox;
    ObjectBoxService.personBox = mockPersonBox;

    taskController = TaskController();
  });

  tearDown(() {
    Get.reset();
  });

  group("recharge des tache de l'api  ", () {
    final loadTasks = [TaskEntity(title: "jouer"), TaskEntity(title: "dormir")];

    when(mockTaskBox.getAll());
  });

  group("description", () {});
}
