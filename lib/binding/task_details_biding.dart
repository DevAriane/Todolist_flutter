import 'package:get/get.dart';
import 'package:todolist_flutter/controller/date_picker_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';

class TaskDetailsBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => DatePickerController(), fenix: true);
  }
}
