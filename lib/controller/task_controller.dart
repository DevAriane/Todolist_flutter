import 'package:flutter/foundation.dart';
import 'package:getxtra/get.dart';

import '../models/task_entity.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';
import './category_controller.dart';

class TaskController extends GetxController {
  final CategoryController _categoryController = Get.find<CategoryController>();
  final tasks = <TaskEntity>[].obs;
  final isLoading = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    loadTasks();
  }

  Future<void> loadTasks() async {
    isLoading(true);
    try {
      await _categoryController.loadCategories();

      final localTasks = ObjectBoxService.taskBox.getAll();
      if (localTasks.isNotEmpty) {
        tasks.value = localTasks;
        return;
      }

      final remoteTasks = await _apiService.fetchTasks();

      for (final json in remoteTasks) {
        final title = (json['title'] ?? '').toString().trim();
        if (title.isEmpty) {
          continue;
        }

        final task = TaskEntity(
          title: title,
          description: (json['description'] ?? '').toString().trim(),
          completed: json['completed'] ?? false,
        );

        final apiCategoryId = json['categoryId'];

        if (apiCategoryId != null) {
          final existingCategory = ObjectBoxService.categoryBox.get(
            apiCategoryId,
          );

          if (existingCategory != null) {
            task.category.target = existingCategory;
          } else {
            debugPrint(
              "Attention : La catégorie avec l'ID $apiCategoryId n'existe pas localement.",
            );
          }
        }
        ObjectBoxService.taskBox.put(task);
      }
      tasks.value = ObjectBoxService.taskBox.getAll();
    } catch (e) {
      debugPrint("Erreur lors du chargement des tâches : $e");
    } finally {
      _refreshFilteredTasks();
      isLoading(false);
    }
  }

  bool addTask(String title, String? description, int? categoryId) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty || categoryId == null) {
      return false;
    }

    final existingCategory = ObjectBoxService.categoryBox.get(categoryId);

    if (existingCategory == null) {
      debugPrint('Categorie non specifiee');
      return false;
    }

    final trimmedDescription = description?.trim();
    final newTask = TaskEntity(
      title: trimmedTitle,
      description: trimmedDescription == null || trimmedDescription.isEmpty
          ? null
          : trimmedDescription,
    );

    newTask.category.target = existingCategory;

    ObjectBoxService.taskBox.put(newTask);
    tasks.add(newTask);
    _refreshFilteredTasks();
    return true;
  }

  void toggleCompleted(TaskEntity task) {
    task.completed = !task.completed;
    ObjectBoxService.taskBox.put(task);
    tasks.refresh();
    _refreshFilteredTasks();
  }

  void deleteTask(TaskEntity task) {
    ObjectBoxService.taskBox.remove(task.id);
    tasks.remove(task);
    _refreshFilteredTasks();
  }

  TaskEntity? getTaskById(int taskId) {
    return ObjectBoxService.taskBox.get(taskId);
  }

  bool updateTaskTitle(int taskId, String newTitle, String? description) {
    final trimmedTitle = newTitle.trim();
    if (trimmedTitle.isEmpty) {
      return false;
    }

    final task = ObjectBoxService.taskBox.get(taskId);
    if (task == null) {
      return false;
    }

    final trimmedDescription = description?.trim();
    task.title = trimmedTitle;
    task.description = trimmedDescription == null || trimmedDescription.isEmpty
        ? null
        : trimmedDescription;
    ObjectBoxService.taskBox.put(task);

    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      tasks[index] = task;
    }

    tasks.refresh();
    _refreshFilteredTasks();
    return true;
  }

  void _refreshFilteredTasks() {
    _categoryController.filteredTaks(
      _categoryController.selectedCategoryId.value,
    );
  }
}
