import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/core/image_ressource.dart';
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

      final allHabits = controller.displayedHabit.value;

      if (allHabits.isEmpty) {
        return const Center(child: Text("Il y'a pas de projet en cours "));
      }

      return Expanded(
        child: ListView.separated(
          itemCount: controller.displayedHabit.length,
          itemBuilder: (context, index) {
            final habit = allHabits[index];
            return Container(
              color: AppColor.habit,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      habit.categoryHabit.target?.iconData ??
                          Icons.help_outline,
                      size: 30,
                      color: AppColor.blanc,
                    ),
                  ),

                  Column(
                    children: [
                      TextWidget(name: habit.title, color: AppColor.blanc),
                      const SizedBox(height: 5),
                      const TextWidget(
                        name: "Completée",
                        color: AppColor.blanc,
                      ),
                    ],
                  ),

                  Image.asset(ImageRessource.tree, height: 24),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
        ),
      );
    });
  }
}
