import 'package:get/get.dart';
import 'package:todolist_flutter/feature/tasks/controllers/category_controller.dart';
import 'package:todolist_flutter/controller/date_picker_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/person_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/task_controller.dart';

class UpdateTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => DatePickerController(), fenix: true);
    Get.lazyPut(() => PersonController(), fenix: true);
  }
}
