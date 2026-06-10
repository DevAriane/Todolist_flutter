import 'package:flutter/foundation.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/task_entity.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';
import 'task_controller.dart'; // ← ajout

class CategoryController extends GetxController {
  final categories = <CategoryEntity>[].obs;
  final isLoading = false.obs;
  final selectedCategoryId = 0.obs;

  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading(true);
    try {
      final localCategories = ObjectBoxService.categoryBox.getAll();
      if (localCategories.isNotEmpty) {
        categories.value = localCategories;
        return;
      }

      final remoteCategories = await _apiService.fetchCategories();
      for (final json in remoteCategories) {
        final name = (json['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        ObjectBoxService.categoryBox.put(CategoryEntity(name: name));
      }
      categories.value = ObjectBoxService.categoryBox.getAll();
    } catch (e) {
      debugPrint('Erreur lors du chargement des categories : $e');
    } finally {
      isLoading(false);
    }
  }

  bool addCategory(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return false;

    final alreadyExists = categories.any(
      (category) => category.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (alreadyExists) return false;

    final category = CategoryEntity(name: trimmedName);
    ObjectBoxService.categoryBox.put(category);
    categories.add(category);
    return true;
  }

  void selectCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
    final taskController = Get.find<TaskController>();
    taskController.applyFilters();
  }
}
