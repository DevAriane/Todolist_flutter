import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/feature/habit/controllers/habit_controller.dart';
import 'package:todolist_flutter/feature/habits/data/models/category_habit_entity.dart';
import '../../../services/api_service.dart';
import '../../../services/objectbox_service.dart';
import '../../../controller/color_controller.dart';

class CategoryHabitController extends GetxController {
  final ColorController _colorController = Get.find<ColorController>();

  final categoriesHabit = <CategoryHabitEntity>[].obs;
  final isLoading = false.obs;
  final selectedCategoryHabitId = 0.obs;
  bool _isAlreadyLoading = false;

  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    loadsCategoriesHabit();
  }

  Future<void> loadsCategoriesHabit() async {
    if (_isAlreadyLoading) return;
    _isAlreadyLoading = true;

    isLoading(true);

    try {
      final localCategoryHabits = ObjectBoxService.categoryHabitBox.getAll();
      if (localCategoryHabits.isNotEmpty) {
        categoriesHabit.value = localCategoryHabits;
        return;
      }

      final remoteCategoriesHabit = await _apiService.fetchCategoriesHabit();
      final List<CategoryHabitEntity> categoryHabitToSave = [];
      for (final json in remoteCategoriesHabit) {
        final name = (json['name'] ?? '').toString().trim();
        final icon = (json['icon'] ?? '').toString().trim();

        final rawColor = json['dbColor'];
        int? parsedColor;

        if (rawColor != null) {
          if (rawColor is num) {
            parsedColor = rawColor.toInt();
          } else if (rawColor is String && rawColor.isNotEmpty) {
            parsedColor = int.tryParse(rawColor);
          }
        }

        categoryHabitToSave.add(
          CategoryHabitEntity(name: name, dbColor: parsedColor, icon: icon),
        );
      }

      if (categoryHabitToSave.isNotEmpty) {
        if (!ObjectBoxService.categoryHabitBox.isEmpty()) {
          ObjectBoxService.categoryHabitBox.removeAll();
        }

        ObjectBoxService.categoryHabitBox.putMany(categoryHabitToSave);
      }

      categoriesHabit.value = ObjectBoxService.categoryHabitBox.getAll();
    } catch (e) {
      debugPrint('Erreur lors du chargement des categories : $e');
    } finally {
      isLoading(false);
      _isAlreadyLoading = false;
    }
  }

  bool addCategoryHabit(String name, icon) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return false;

    final alreadyExists = categoriesHabit.any(
      (category) => category.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (alreadyExists) return false;

    final categoryHabit = CategoryHabitEntity(
      name: name,
      color: _colorController.selectedColor.value,
      icon: icon,
    );
    ObjectBoxService.categoryHabitBox.put(categoryHabit);
    categoriesHabit.insert(0, categoryHabit);

    return true;
  }

  void selectCategoryHabit(int categoryHabitId) {
    selectedCategoryHabitId.value = categoryHabitId;
    final habitController = Get.find<HabitController>();
    habitController.applyFilterHabit();
  }
}
