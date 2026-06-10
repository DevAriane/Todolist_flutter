import 'package:getxtra/get.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import "./task_controller.dart";
import '../services/objectbox_service.dart';
import '../controller/category_controller.dart';

class SearchController extends GetxController {
  final TaskController taskController = Get.find<TaskController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  var searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    migrateExistingTasks();
  }

  String _normalize(String input) {
    if (input.isEmpty) return input;
    String normalized = input.toLowerCase();
    normalized = normalized
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[àâä]'), 'a')
        .replaceAll(r'[ùûü]', 'u')
        .replaceAll(r'[îï]', 'i')
        .replaceAll(r'[ôö]', 'o')
        .replaceAll(r'[ç]', 'c')
        .replaceAll(r'[œ]', 'oe')
        .replaceAll(r'[æ]', 'ae');
    return normalized;
  }

  Future<void> migrateExistingTasks() async {
    final allTasks = ObjectBoxService.taskBox.getAll();
    bool needsUpdate = false;
    for (var task in allTasks) {
      final normalized = _normalize(task.title);
      if (task.titleNormalized != normalized) {
        task.titleNormalized = normalized;
        needsUpdate = true;
      }
    }
    if (needsUpdate) {
      await ObjectBoxService.taskBox.putManyAsync(allTasks);
      print('Migration terminée : ${allTasks.length} tâches mises à jour');
    } else {
      print('Aucune migration nécessaire');
    }
  }

  void searchTask() {
    if (searchQuery.value.isEmpty) return;

    isLoading.value = true;

    final normalizedQuery = _normalize(searchQuery.value);

    final query = ObjectBoxService.taskBox
        .query(TaskEntity_.titleNormalized.contains(normalizedQuery))
        .build();

    final results = query.find();
    taskController.displayedTasks.value = results;

    query.close();
    isLoading.value = false;
  }

  void resetSearch() {
    searchQuery.value = '';
    isLoading.value = false;
    taskController.applyFilters();
  }
}
