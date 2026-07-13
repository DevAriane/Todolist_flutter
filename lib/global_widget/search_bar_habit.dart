import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../core/app_color.dart';
import '../feature/tasks/data/search_controller.dart';

class SearchbarsHabit extends StatelessWidget {
  SearchbarsHabit({super.key});

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
            _searchController.resetSearchHabit();
          } else {
            _searchController.searchQuery.value = value.trim();
            _searchController.searchHabit();
          }
        },
        decoration: InputDecoration(
          hintText: "Rechercher...",
          hintStyle: const TextStyle(color: AppColor.placeholder),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 10,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: AppColor.buttonColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: AppColor.bordure),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: AppColor.buttonColor,
                size: 40,
              ),
              onPressed: () {
                if (_search.text.trim().isNotEmpty) {
                  _searchController.searchQuery.value = _search.text.trim();
                  _searchController.searchHabit();
                } else {
                  _searchController.resetSearchHabit();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
