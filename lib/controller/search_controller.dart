import 'package:getxtra/get.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/task_entity.dart';
import "./task_controller.dart";
import '../services/objectbox_service.dart';
import '../controller/category_controller.dart';

class SearchController extends GetxController {
  final TaskController controller = Get.find<TaskController>();
  final CategoryController _categoryController = Get.find<CategoryController>();

  @override
  void onReady() {
    super.onReady();
  }

  void searchTask(String title) {
    Query<TaskEntity> query = ObjectBoxService.taskBox
        .query(TaskEntity_.title.contains(title))
        .build();

    controller.tasks.value = query.find();
    _categoryController.taksCategories.value = query.find();
    query.close();
  }
}
