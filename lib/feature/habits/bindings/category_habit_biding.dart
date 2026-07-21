import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:todolist_flutter/feature/habits/controllers/category_habit_controller.dart';

class CategoryHabitBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryHabitController(), fenix: true);
  }
}
