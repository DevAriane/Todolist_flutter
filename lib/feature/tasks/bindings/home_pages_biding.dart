import 'package:get/get.dart';
import 'package:todolist_flutter/controller/date_picker_controller.dart';
import 'package:todolist_flutter/feature/tasks/controllers/task_controller.dart';

class HomePagesBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => DatePickerController(), fenix: true);
  }
}
