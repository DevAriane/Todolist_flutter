import 'package:get/get.dart';
import 'package:todolist_flutter/controller/category_controller.dart';
import 'package:todolist_flutter/controller/person_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';

class TasksBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => PersonController(), fenix: true);
  }
}
