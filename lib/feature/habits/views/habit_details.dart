import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/global_widget/app_bottom_sheet.dart';
import '../data/models/habit_entity.dart';
import '../../habit/controllers/habit_controller.dart';

class HabitDetails extends StatelessWidget {
  final HabitEntity habit;

  const HabitDetails({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find<HabitController>();
    final dateFormat = DateFormat('dd MMM yyyy');

    return AppBottomSheet(
      child: Obx(() {
        final currentHabit = controller.habits.firstWhere(
          (h) => h.id == habit.id,
          orElse: () => habit,
        );

        final total = currentHabit.totalDaysChallenge;
        final completed = currentHabit.completedDaysCount;
        final ratio = currentHabit.progressRatio;
        final isDoneToday = currentHabit.isCompletedToday;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (currentHabit.categoryHabit.target?.icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          currentHabit.categoryHabit.target?.color?.withValues(
                            alpha: 0.15,
                          ) ??
                          Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentHabit.categoryHabit.target!.iconData,
                      color:
                          currentHabit.categoryHabit.target?.color ??
                          AppColor.or,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentHabit.title,
                        style: const TextStyle(
                          color: AppColor.noir,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentHabit.categoryHabit.target != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          currentHabit.categoryHabit.target!.name,
                          style: TextStyle(
                            color:
                                currentHabit.categoryHabit.target?.color ??
                                AppColor.or,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (currentHabit.decription != null &&
                currentHabit.decription!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentHabit.decription!,
                  style: const TextStyle(
                    color: AppColor.habit,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Progression",
                      style: TextStyle(color: AppColor.noir, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$completed / $total jours",
                      style: const TextStyle(
                        color: AppColor.noir,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${(ratio * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(
                    color: AppColor.noir,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDoneToday ? AppColor.buttonColor : AppColor.inputBorder,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateInfo(
                  "Début",
                  dateFormat.format(currentHabit.startDate),
                ),
                _buildDateInfo("Fin", dateFormat.format(currentHabit.endDate)),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => controller.toggleHabitCompletion(currentHabit),
                icon: Icon(
                  isDoneToday
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isDoneToday ? AppColor.noir : AppColor.noir,
                ),
                label: Text(
                  isDoneToday
                      ? "Validé pour aujourd'hui"
                      : "Marquer comme fait aujourd'hui",
                  style: TextStyle(
                    color: isDoneToday ? AppColor.noir : AppColor.noir,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: isDoneToday
                        ? AppColor.buttonColor
                        : AppColor.bordure,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDateInfo(String label, String dateText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColor.noir, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          dateText,
          style: const TextStyle(
            color: AppColor.noir,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
