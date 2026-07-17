import 'package:get/get.dart';
import 'package:todolist_flutter/feature/tasks/controllers/category_controller.dart';
import 'package:todolist_flutter/feature/habit/controllers/category_habit_controller.dart';
import 'package:todolist_flutter/feature/habit/controllers/habit_controller.dart';
import 'package:todolist_flutter/controller/navigation_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/person_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/search_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/task_controller.dart';
import 'package:todolist_flutter/controller/todo_controller.dart';
import 'package:todolist_flutter/controller/user_controller.dart';

class NavigationBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => CategoryHabitController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => PersonController(), fenix: true);
    Get.lazyPut(() => HabitController(), fenix: true);
    Get.lazyPut(() => TodoController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
  }
}
