import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/task_entity.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';
import './category_controller.dart';
import './person_controller.dart';

class TaskController extends GetxController {
  final CategoryController categoryController = Get.find<CategoryController>();
  final PersonController personController = Get.find<PersonController>();

  final tasks = <TaskEntity>[].obs;
  final isLoading = false.obs;
  final selectedFilterDate = DateTime.now().obs;
  final displayedTasks = <TaskEntity>[].obs;

  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    loadTasks();
  }

  String _normalize(String input) {
    if (input.isEmpty) return input;
    String normalized = input.toLowerCase();
    normalized = normalized
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[àâä]'), 'a')
        .replaceAll(RegExp(r'[ùûü]'), 'u')
        .replaceAll(RegExp(r'[îï]'), 'i')
        .replaceAll(RegExp(r'[ôö]'), 'o')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[œ]'), 'oe')
        .replaceAll(RegExp(r'[æ]'), 'ae');
    return normalized;
  }

  void applyFilters() {
    List<TaskEntity> result = tasks.toList();

    final catId = categoryController.selectedCategoryId.value;
    if (catId != 0) {
      result = result
          .where((task) => task.category.target?.id == catId)
          .toList();
    }

    final date = selectedFilterDate.value;
    result = result.where((task) {
      if (task.date == null) return false;
      return task.date!.year == date.year &&
          task.date!.month == date.month &&
          task.date!.day == date.day;
    }).toList();

    displayedTasks.value = result;
  }

  Future<void> loadTasks() async {
    isLoading(true);
    try {
      await categoryController.loadCategories();
      await personController.loadPersons();

      final localTasks = ObjectBoxService.taskBox.getAll();
      if (localTasks.isNotEmpty) {
        tasks.value = localTasks;
        applyFilters();
        isLoading(false);
      }

      final remoteData = await _apiService.fetchTasks();
      final List<Map<String, dynamic>> remoteTasks = remoteData
          .cast<Map<String, dynamic>>();

      if (remoteTasks.isNotEmpty) {
        final List<TaskEntity> tasksToSave = [];

        for (final json in remoteTasks) {
          final title = (json['title'] ?? '').toString().trim();
          if (title.isEmpty) continue;

          final int apiId = json['id'] ?? 0;

          DateTime? parsedDate;
          if (json['date'] != null && json['date'].toString().isNotEmpty) {
            parsedDate = DateTime.tryParse(json['date'].toString());
          }

          Color? parsedColor;
          if (json['dbColor'] != null && json['dbColor'] is int) {
            parsedColor = Color(json['dbColor']);
          }

          TaskEntity? task;
          if (apiId != 0) {
            task = ObjectBoxService.taskBox.get(apiId);
          }

          if (task != null) {
            task.title = title;
            task.description = json['description']?.toString().trim();
            task.completed = json['completed'] ?? false;
            task.color = parsedColor;
            task.date = parsedDate;
            task.startTime = json['startTime'] as String?;
            task.endTime = json['endTime'] as String?;
            task.remindMe = json['remindMe'] ?? false;
            task.link = json['link'] as String? ?? "";
            task.photoPath = json['photoPath'] as String? ?? "";
            task.titleNormalized = _normalize(title);
          } else {
            task = TaskEntity(
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
              titleNormalized: _normalize(title),
            );
            if (apiId != 0) task.id = apiId;
          }

          final apiCategoryId = json['categoryId'];
          if (apiCategoryId != null) {
            final existingCategory = ObjectBoxService.categoryBox.get(
              apiCategoryId,
            );
            if (existingCategory != null) {
              task.category.target = existingCategory;
            }
          }

          final apiPersonId = json['personId'];
          if (apiPersonId != null) {
            final existingPerson = ObjectBoxService.personBox.get(apiPersonId);
            if (existingPerson != null) {
              task.person.target = existingPerson;
            }
          }

          tasksToSave.add(task);
        }

        if (tasksToSave.isNotEmpty) {
          ObjectBoxService.taskBox.putMany(tasksToSave);
        }

        tasks.value = ObjectBoxService.taskBox.getAll();
      }
    } catch (e) {
      debugPrint("Erreur lors de la synchronisation des tâches : $e");
    } finally {
      isLoading(false);
      applyFilters();
    }
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
  }) {
    verifyNameTask(title, categoryId);

    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return false;

    final existingCategory = ObjectBoxService.categoryBox.get(categoryId);
    if (existingCategory == null) return false;

    final existingPerson = ObjectBoxService.personBox.get(personId);
    if (existingPerson == null) return false;

    final newTask = TaskEntity(
      title: trimmedTitle,
      description: description?.trim().isEmpty == true
          ? null
          : description?.trim(),
      color: color,
      date: date,
      startTime: startTime,
      titleNormalized: _normalize(title),
      endTime: endTime,
      remindMe: remindMe,
      link: link,
      photoPath: photoPath,
    );

    newTask.category.target = existingCategory;
    newTask.person.target = existingPerson;

    ObjectBoxService.taskBox.put(newTask);
    tasks.add(newTask);
    applyFilters();
    return true;
  }

  void toggleCompleted(TaskEntity task) {
    task.completed = !task.completed;
    ObjectBoxService.taskBox.put(task);
    tasks.refresh();
    applyFilters();
  }

  void deleteTask(TaskEntity task) {
    ObjectBoxService.taskBox.remove(task.id);
    tasks.remove(task);
    applyFilters();
  }

  void verifyNameTask(String newTitle, int categoryId) {
    final query = ObjectBoxService.taskBox
        .query(TaskEntity_.category.equals(categoryId))
        .build();
    final tasksInCategory = query.find();
    for (final task in tasksInCategory) {
      if (task.title == newTitle) {
        debugPrint("Doublon détecté dans cette catégorie.");
      }
    }
    query.close();
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
    if (index != -1) {
      tasks[index] = task;
    }

    tasks.refresh();
    applyFilters();
    return true;
  }
}
