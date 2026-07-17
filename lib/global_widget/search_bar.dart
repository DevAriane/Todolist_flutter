import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../core/app_color.dart';
import '../feature/tasks/controllers/search_controller.dart';

class Searchbars extends StatelessWidget {
  Searchbars({super.key});

  final SearchController _searchController = Get.find<SearchController>();
  final TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),

      child: TextField(
        controller: _search,
        style: const TextStyle(color: AppColor.blanc),
        onChanged: (value) {
          if (value.trim().isEmpty) {
            _searchController.resetSearch();
          } else {
            _searchController.searchQuery.value = value.trim();
            _searchController.searchTask();
          }
        },
        decoration: InputDecoration(
          hintText: "Rechercher...",
          hintStyle: const TextStyle(color: AppColor.placeholder),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.placeholder,
            size: 50,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 10,
              decoration: const BoxDecoration(
                color: AppColor.or,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: AppColor.noir, size: 15.0),
                onPressed: () {
                  if (_search.text.trim().isNotEmpty) {
                    _searchController.searchQuery.value = _search.text.trim();
                    _searchController.searchTask();
                  } else {
                    _searchController.resetSearch();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
