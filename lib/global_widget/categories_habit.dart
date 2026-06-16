import 'package:flutter/material.dart' hide SearchController;
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/global_widget/create_category_habit.dart';
import '../core/app_color.dart';
import '../controller/category_habit_controller.dart';
import 'create_category.dart';

class CategoriesHabit extends StatelessWidget {
  final CategoryHabitController controller =
      Get.find<CategoryHabitController>();

  CategoriesHabit({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text("Catégories", style: TextStyle(color: AppColor.blanc)),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: false,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const CreateCategoryHabit();
                  },
                );
              },
              icon: const Icon(Icons.add_circle, color: AppColor.blanc),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: Obx(() {
            final categories = controller.categoriesHabit;
            if (categories.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune catégorie',
                  style: TextStyle(color: AppColor.blanc),
                ),
              );
            }
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    controller.selectedCategoryHabitId(0);
                  },
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: controller.selectedCategoryHabitId.value == 0
                          ? Colors.blue
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Tout ",
                        style: TextStyle(color: AppColor.blanc),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return InkWell(
                        onTap: () {
                          controller.selectCategoryHabit(category.id);
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color:
                                controller.selectedCategoryHabitId.value ==
                                    category.id
                                ? Colors.blue
                                : Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              style: const TextStyle(color: AppColor.blanc),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
