import 'package:get/get.dart';
import 'package:todolist_flutter/feature/habit/controllers/category_habit_controller.dart';
import 'package:todolist_flutter/feature/habit/controllers/habit_controller.dart';

class HabitBiding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut(() => CategoryHabitController(), fenix: true);
     Get.lazyPut(() => HabitController(), fenix: true);
  }
}
