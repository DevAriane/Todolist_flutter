import 'package:get/get.dart';
import 'package:todolist_flutter/controller/date_picker_controller.dart';
import 'package:todolist_flutter/controller/todo_controller.dart';

class TodoDetailsBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoController(), fenix: true);
    Get.lazyPut(() => DatePickerController(), fenix: true);
  }
}
