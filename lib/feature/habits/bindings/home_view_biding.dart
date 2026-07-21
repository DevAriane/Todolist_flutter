import 'package:get/get.dart';
import 'package:todolist_flutter/feature/habits/controllers/category_habit_controller.dart';
import 'package:todolist_flutter/feature/habits/controllers/habit_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/search_controller.dart';

class HomeViewBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryHabitController(), fenix: true);
    Get.lazyPut(() => HabitController(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
  }
}
