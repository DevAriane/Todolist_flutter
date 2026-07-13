import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'package:todolist_flutter/services/objectbox_service.dart';
import 'category_habit_controller.dart';
import '../../habits/data/models/habit_entity.dart';

class HabitController extends GetxController {
  final CategoryHabitController categoryHabit =
      Get.find<CategoryHabitController>();
  final habits = <HabitEntity>[].obs;
  final isLoading = false.obs;
  final ApiService _apiService = ApiService();
  bool _isAlreadyLoading = false;
  final displayedHabit = <HabitEntity>[].obs;

  @override
  void onReady() {
    super.onReady();
    loadsHabit();
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

  void applyFilterHabit() {
    List<HabitEntity> result = habits.toList();

    final catHabitId = categoryHabit.selectedCategoryHabitId.value;
    if (catHabitId != 0) {
      result = result
          .where((habit) => habit.categoryHabit.target?.id == catHabitId)
          .toList();
    }

    displayedHabit.value = result;
  }

  Future<void> loadsHabit() async {
    if (_isAlreadyLoading) return;
    _isAlreadyLoading = true;

    isLoading(true);

    try {
      await categoryHabit.loadsCategoriesHabit();

      final localsHabit = ObjectBoxService.habitBox.getAll();
      if (localsHabit.isNotEmpty) {
        habits.value = localsHabit;
      }

      final remoteHabitJson = await _apiService.fetchHabits();
      if (remoteHabitJson.isNotEmpty) {
        final List<HabitEntity> habitToSave = [];

        for (final json in remoteHabitJson) {
          final title = json['title'] ?? "";
          final description = json['description'] ?? "";

          final startDate = json['startDate'] != null
              ? DateTime.parse(json['startDate'])
              : DateTime.now();
          final endDate = json['endDate'] != null
              ? DateTime.parse(json['endDate'])
              : DateTime.now();

          final titleNormalized = _normalize(title);
          final apiCategoryHabitId = json['categoryHabitId'];

          final habit = HabitEntity(
            title: title,
            decription: description,
            startDate: startDate,
            endDate: endDate,
            titleNormalized: titleNormalized,
          );

          if (apiCategoryHabitId != null) {
            final existingCategoryHabit = ObjectBoxService.categoryHabitBox.get(
              apiCategoryHabitId,
            );

            if (existingCategoryHabit != null) {
              habit.categoryHabit.target = existingCategoryHabit;
            }
          }
          habitToSave.add(habit);
        }

        if (habitToSave.isNotEmpty) {
          ObjectBoxService.habitBox.removeAll();
          ObjectBoxService.habitBox.putMany(habitToSave);
        }

        habits.value = ObjectBoxService.habitBox.getAll();
      }
    } catch (e) {
      print("Erreur lors du chargement des habitudes: $e");
    } finally {
      applyFilterHabit();
      isLoading(false);
      _isAlreadyLoading = false;
    }
  }

  void toggleHabitCompletion(HabitEntity habit) {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    if (habit.completedDates.contains(todayStr)) {
      habit.completedDates.remove(todayStr);
    } else {
      habit.completedDates.add(todayStr);
    }

    ObjectBoxService.habitBox.put(habit);
    habits.refresh();
  }

  void verifyNameHabit(String newTitle, int categoryHabitId) {
    final query = ObjectBoxService.habitBox
        .query(HabitEntity_.categoryHabit.equals(categoryHabitId))
        .build();
    final habitsInCategory = query.find();
    for (final habit in habitsInCategory) {
      if (habit.title == newTitle) {
        debugPrint("Doublon détecté dans cette catégorie.");
      }
    }
    query.close();
  }

  bool addHabits({
    required String title,
    String? description,
    required int categoryHabitId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    verifyNameHabit(title, categoryHabitId);

    final newHabit = HabitEntity(
      title: title,
      decription: description,
      startDate: startDate,
      endDate: endDate,
      titleNormalized: _normalize(title),
    );

    final existingCategoryHabit = ObjectBoxService.categoryHabitBox.get(
      categoryHabitId,
    );
    if (existingCategoryHabit != null) {
      newHabit.categoryHabit.target = existingCategoryHabit;
    }

    ObjectBoxService.habitBox.put(newHabit);
    habits.insert(0, newHabit);
    applyFilterHabit();
    return true;
  }

  void deleteHabit(HabitEntity habit) {
    ObjectBoxService.habitBox.remove(habit.id);
    habits.remove(habit);
    applyFilterHabit();
  }
}
