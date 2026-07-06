import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'package:todolist_flutter/feature/habit/controllers/category_habit_controller.dart';
import 'package:todolist_flutter/feature/habit/controllers/habit_controller.dart';
import 'package:todolist_flutter/models/category_entity.dart';

class MockCategoryHabitController extends CategoryHabitController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}

class MockHabitController extends HabitController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}

void main() {
  late MockCategoryHabitController mockCategoryHabitController;
}
