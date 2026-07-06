import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/feature/habits/views/habit_details.dart';
import '../../habit/controllers/habit_controller.dart';
import '../../../core/app_color.dart';
import '../../../global_widget/text_widget.dart';

class Habits extends StatelessWidget {
  Habits({super.key});

  final HabitController controller = Get.find<HabitController>();

  void _openDialog(BuildContext context, habit) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer ?'),
          content: const Text('Voulez-vous vraiment supprimer ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteHabit(habit);
                Navigator.pop(context);
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

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
                    border: Border.all(color: AppColor.blanc),
                  ),
                  child: Icon(
                    habit.categoryHabit.target?.iconData,
                    size: 30,
                    color: AppColor.blanc,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return HabitDetails(habit: habit);
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(name: habit.title, color: AppColor.blanc),
                        const SizedBox(height: 5),

                        Row(
                          children: [
                            const TextWidget(
                              name: "Completée",
                              color: AppColor.blanc,
                            ),
                            const SizedBox(width: 5),
                            TextWidget(
                              name:
                                  "${habit.completedDaysCount}/${habit.totalDaysChallenge}",
                              color: AppColor.blanc,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: habit.progressRatio,
                                backgroundColor: const Color(0xFF838995),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColor.buttonColor,
                                ),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "${(habit.progressRatio * 100).toStringAsFixed(2)}%",
                              style: const TextStyle(
                                color: AppColor.buttonColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    _openDialog(context, habit);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 24,
                    color: AppColor.blanc,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      );
    });
  }
}
