import 'package:get/get.dart';
import 'package:todolist_flutter/controller/navigation_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';
import 'package:todolist_flutter/controller/todo_controller.dart';
import 'package:todolist_flutter/controller/user_controller.dart';

class NavigationBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => TodoController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
