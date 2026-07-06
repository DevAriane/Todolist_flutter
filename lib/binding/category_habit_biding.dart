import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:todolist_flutter/feature/habit/controllers/category_habit_controller.dart'
    show CategoryHabitController;

class CategoryHabitBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryHabitController(), fenix: true);
  }
}
