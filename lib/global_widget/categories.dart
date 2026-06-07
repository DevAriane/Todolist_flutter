import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import '../core/app_color.dart';
import '../controller/category_controller.dart';
import 'create_category.dart';

class Categories extends StatelessWidget {
  final CategoryController controller = Get.find<CategoryController>();

  Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text("Categories", style: TextStyle(color: AppColor.blanc)),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: false,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const CreateCategory();
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
            final categories = controller.categories;
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
                    controller.filteredTaks(0);
                  },
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: controller.selectedCategoryId.value == 0
                          ? Colors.blue
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "All",
                        style: TextStyle(color: AppColor.blanc),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return InkWell(
                        onTap: () {
                          controller.filteredTaks(category.id);
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color:
                                controller.selectedCategoryId.value ==
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
