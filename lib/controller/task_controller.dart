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
        if (title.isEmpty) continue;

        DateTime? parsedDate;
        if (json['date'] != null && json['date'].toString().isNotEmpty) {
          parsedDate = DateTime.tryParse(json['date'].toString());
        }

        Color? parsedColor;
        if (json['dbColor'] != null && json['dbColor'] is int) {
          parsedColor = Color(json['dbColor']);
        }

        final task = TaskEntity(
          title: title,
          description: json['description']?.toString().trim(),
          completed: json['completed'] ?? false,
          color: parsedColor,
          date: parsedDate,
          startTime: json['startTime'] as String?,
          endTime: json['endTime'] as String?,
          remindMe: json['remindMe'] ?? false,
          link: json['link'] as String? ?? "",
          photoPath: json['photoPath'] as String? ?? "",
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
              "Attention : la catégorie ID $apiCategoryId n'existe pas localement.",
            );
          }
        }

        final apiPersonId = json['personId'];
        if (apiPersonId != null) {
          final existingPerson = ObjectBoxService.personBox.get(apiPersonId);
          if (existingPerson != null) {
            task.person.target = existingPerson;
          } else {
            debugPrint(
              "Attention : la personne ID $apiPersonId n'existe pas localement.",
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
    print('Tâches en base : ${ObjectBoxService.taskBox.getAll().length}');
  }

  bool addTask({
    required String title,
    String? description,
    required int categoryId,
    required int personId,
    Color? color,
    DateTime? date,
    String? startTime,
    String? endTime,
    bool remindMe = false,
    String? link,
    String? photoPath,
    List<String>? tags,
  }) {
    verifyNameTask(title, categoryId);

    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return false;

    final existingCategory = ObjectBoxService.categoryBox.get(categoryId);
    if (existingCategory == null) {
      debugPrint('Catégorie non spécifiée');
      return false;
    }

    final existingPerson = ObjectBoxService.personBox.get(personId);
    if (existingPerson == null) {
      debugPrint('Personne non spécifiée');
      return false;
    }

    final newTask = TaskEntity(
      title: trimmedTitle,
      description: description?.trim().isEmpty == true
          ? null
          : description?.trim(),
      color: color,
      date: date,
      startTime: startTime,
      endTime: endTime,
      remindMe: remindMe,
      link: link,
      photoPath: photoPath,
      tags: tags,
    );

    newTask.category.target = existingCategory;
    newTask.person.target = existingPerson;

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
    String? startTime,
    String? endTime,
    bool remindMe,
    String? link,
    String? photoPath,
  ) {
    verifyNameTask(newTitle, categoryId);

    final trimmedTitle = newTitle.trim();
    if (trimmedTitle.isEmpty) return false;

    final task = ObjectBoxService.taskBox.get(taskId);
    if (task == null) return false;

    final existingCategory = ObjectBoxService.categoryBox.get(categoryId);
    if (existingCategory == null) {
      debugPrint('Catégorie non spécifiée');
      return false;
    }

    final existingPerson = ObjectBoxService.personBox.get(personId);
    if (existingPerson == null) {
      debugPrint('Personne non spécifiée');
      return false;
    }

    task.title = trimmedTitle;
    task.description = description?.trim().isEmpty == true
        ? null
        : description?.trim();
    task.color = color;
    task.date = date;
    task.startTime = startTime;
    task.endTime = endTime;
    task.remindMe = remindMe;
    task.link = link;
    task.photoPath = photoPath;
    task.category.target = existingCategory;
    task.person.target = existingPerson;

    ObjectBoxService.taskBox.put(task);

    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) tasks[index] = task;

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
    final query = ObjectBoxService.taskBox
        .query(TaskEntity_.category.equals(categoryId))
        .build();
    final tasksInCategory = query.find();
    for (final task in tasksInCategory) {
      if (task.title == newTitle) {
        debugPrint(
          "Dans une même catégorie, on ne peut pas avoir deux tâches avec le même nom.",
        );
      }
    }
    query.close();
  }

  void filteredTaskByDate(DateTime selectedDate) {
    final startOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      0,
      0,
      0,
    );
    final endOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
      59,
    );

    final query = ObjectBoxService.taskBox
        .query(
          TaskEntity_.date.between(
            startOfDay.millisecondsSinceEpoch,
            endOfDay.millisecondsSinceEpoch,
          ),
        )
        .build();

    categoryController.taksCategories.value = query.find();
    query.close();
  }
}
