import 'package:getxtra/get.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/task_entity.dart';
import "./task_controller.dart";
import '../services/objectbox_service.dart';
import '../controller/category_controller.dart';

class SearchController extends GetxController {
  final TaskController controller = Get.find<TaskController>();
  final CategoryController _categoryController = Get.find<CategoryController>();

  var searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  void searchTask() {
    if (searchQuery.value.isEmpty) return;

    isLoading.value = true;

    Query<TaskEntity> query = ObjectBoxService.taskBox
        .query(TaskEntity_.title.contains(searchQuery.value))
        .build();

    List<TaskEntity> results = query.find();
    controller.tasks.value = results;
    _categoryController.taksCategories.value = results;

    query.close();
    isLoading.value = false;
  }

  void resetSearch() {
    searchQuery.value = '';
    isLoading.value = false;
    _categoryController.filteredTaks(
      _categoryController.selectedCategoryId.value,
    );
  }
}
