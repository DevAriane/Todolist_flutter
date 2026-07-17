import 'package:get/get.dart';
import 'package:todolist_flutter/feature/tasks/controllers/search_controller.dart';
import 'package:todolist_flutter/controller/todo_controller.dart';

class TodoBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoController(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
  }
}
