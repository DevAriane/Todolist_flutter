import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/objectbox.g.dart';

import '../models/task_entity.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';
import './category_controller.dart';

class TaskController extends GetxController {
  final CategoryController categoryController = Get.find<CategoryController>();
  final tasks = <TaskEntity>[].obs;
  final isLoading = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    loadTasks();
    filteredTaskByDate(DateTime.now().day);
  }

  Future<void> loadTasks() async {
    isLoading(true);
    try {
      await categoryController.loadCategories();

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

        final apiPersonId = json['personId'];

        if (apiPersonId != null) {
          final existingPerson = ObjectBoxService.personBox.get(apiPersonId);

          if (existingPerson != null) {
            task.person.target = existingPerson;
          } else {
            "Attention : la personne avec l'ID $apiPersonId n'existe pas localement";
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

  bool addTask(
    String title,
    String? description,
    int categoryId,
    int personId,
    Color? color,
    DateTime? date,
  ) {
    verifyNameTask(title, categoryId);

    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
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
      color: color,
      date: date,
    );

    newTask.category.target = existingCategory;

    final existingPersong = ObjectBoxService.personBox.get(personId);

    if (existingPersong == null) {
      debugPrint('Personne non specifiee');
      return false;
    }
    newTask.person.target = existingPersong;

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

  bool updateTaskTitle(
    int taskId,
    String newTitle,
    String? description,
    int categoryId,
    int personId,
    Color? color,
    DateTime? date,
  ) {
    verifyNameTask(newTitle, categoryId);

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

    final existingCategory = ObjectBoxService.categoryBox.get(categoryId);

    if (existingCategory == null) {
      debugPrint('Categorie non specifiee');
      return false;
    }

    task.category.target = existingCategory;

    final existingPersong = ObjectBoxService.personBox.get(personId);

    if (existingPersong == null) {
      debugPrint('Personne non specifiee');
      return false;
    }
    task.person.target = existingPersong;
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
    categoryController.filteredTaks(
      categoryController.selectedCategoryId.value,
    );
  }

  void verifyNameTask(String newTitle, int categoryId) {
    Query<TaskEntity> query = ObjectBoxService.taskBox
        .query(TaskEntity_.category.equals(categoryId))
        .build();

    final taksCategories = query.find();
    for (TaskEntity task in taksCategories) {
      if (task.title == newTitle) {
        debugPrint(
          "dans une meme categorie on ne peut pas avoir deux taches avec le meme non",
        );
        return;
      }
    }
  }

  void filteredTaskByDate(int date) {
    Query<TaskEntity> query = ObjectBoxService.taskBox
        .query(TaskEntity_.date.equals(date))
        .build();

    categoryController.taksCategories.value = query.find();
  }
}
