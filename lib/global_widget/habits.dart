import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/core/image_ressource.dart';
import 'package:todolist_flutter/global_widget/habit_details.dart';
import '../controller/habit_controller.dart';
import '../core/app_color.dart';
import 'text_widget.dart';

class Habits extends StatelessWidget {
  Habits({super.key});

  final HabitController controller = Get.find<HabitController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final allHabits = controller.displayedHabit;

      if (allHabits.isEmpty) {
        return const Center(child: Text("Il y'a pas de projet en cours "));
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allHabits.length,
        itemBuilder: (context, index) {
          final habit = allHabits[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColor.habit,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    habit.categoryHabit.target?.iconData,
                    size: 30,
                    color: AppColor.blanc,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(name: habit.title, color: AppColor.blanc),
                      const SizedBox(height: 5),
                      const TextWidget(
                        name: "Completée",
                        color: AppColor.blanc,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                               onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const HabitDetails();
                  },
                );
              },
                  child: Image.asset(ImageRessource.tree, height: 24)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      );
    });
  }
}
