import 'package:getxtra/get.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'package:todolist_flutter/services/objectbox_service.dart';
import './category_habit_controller.dart';
import '../models/habit_entity.dart';
import '../controller/color_controller.dart';

class HabitController extends GetxController {
  final ColorController _colorController = Get.find<ColorController>();

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
      await CategoryHabitController().loadsCategoriesHabit();

      final localsHabit = ObjectBoxService.habitBox.getAll();
      if (localsHabit.isNotEmpty) {
        habits.value = localsHabit;
      }

      final remoteHabitJson = await _apiService.fetchTasks();
      if (remoteHabitJson.isNotEmpty) {
        final List<HabitEntity> habitToSave = [];
        final localCategoriesHabit = ObjectBoxService.categoryHabitBox.getAll();

        for (final json in remoteHabitJson) {
          final title = json['title'] ?? "";
          final description = json['description'] ?? "";
          final startDate = json['startDate'] ?? "";
          final endDate = json['endDate'] ?? "";
          final isCompletedToday = json['isCompletedToday'] ?? false;
          final titleNormalized = _normalize(title);
          final apiCategortHabitId = json['categoryHabitId'];
          final habit = HabitEntity(
            title: title,
            decription: description,
            startDate: startDate,
            endDate: endDate,
            isCompletedToday: isCompletedToday,
            titleNormalized: titleNormalized,
          );
          if (apiCategortHabitId != null) {
            final existingCategoryHabit = ObjectBoxService.categoryHabitBox.get(
              apiCategortHabitId,
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
      print(e);
    } finally {
      applyFilterHabit();
      isLoading(false);
      _isAlreadyLoading = false;
    }
  }
}
