import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../../../services/api_service.dart';
import '../../../services/objectbox_service.dart';
import 'task_controller.dart';

class CategoryController extends GetxController {
  final categories = <CategoryEntity>[].obs;
  final isLoading = false.obs;
  final selectedCategoryId = 0.obs;

  bool _isAlreadyLoading = false;

  final ApiService _apiService;
  final Box<CategoryEntity> _categoryBox;

  CategoryController({ApiService? apiService, Box<CategoryEntity>? categoryBox})
    : _apiService = apiService ?? ApiService(),
      _categoryBox = categoryBox ?? ObjectBoxService.categoryBox;

  @override
  void onReady() {
    super.onReady();
    loadCategories();
  }

  Future<void> loadCategories() async {
    if (_isAlreadyLoading) return;
    _isAlreadyLoading = true;

    isLoading(true);
    try {
      final localCategories = _categoryBox.getAll();
      if (localCategories.isNotEmpty) {
        categories.value = localCategories;
        return;
      }

      final remoteCategories = await _apiService.fetchCategories();
      final List<CategoryEntity> categoriesToSave = [];

      for (final json in remoteCategories) {
        final name = (json['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;

        categoriesToSave.add(CategoryEntity(name: name));
      }

      if (categoriesToSave.isNotEmpty) {
        if (!_categoryBox.isEmpty()) {
          _categoryBox.removeAll();
        }

        _categoryBox.putMany(categoriesToSave);
      }

      categories.value = _categoryBox.getAll();
    } catch (e) {
      debugPrint('Erreur lors du chargement des categories : $e');
    } finally {
      isLoading(false);
      _isAlreadyLoading = false;
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
    _categoryBox.put(category);
    categories.insert(0, category);
    return true;
  }

  void selectCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
    final taskController = Get.find<TaskController>();
    taskController.applyFilters();
  }
}
