import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';
import '../core/app_color.dart';
import '../models/task_entity.dart';
import 'app_bottom_sheet.dart';

class DetailsTasks extends StatelessWidget {
  final TaskEntity task;
  DetailsTasks({super.key, required this.task});

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final personName = task.person.target?.name;
    final description = task.description;

    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (description != null && description.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(description),
          ],
          if (personName != null && personName.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text("Assignée à : $personName"),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Compléter la tâche", style: TextStyle(fontSize: 16)),
              IconButton(
                onPressed: () {
                  controller.toggleCompleted(task);
                  Navigator.of(context).pop();
                },
                icon: task.completed
                    ? const Icon(Icons.toggle_on, size: 40, color: AppColor.or)
                    : const Icon(
                        Icons.toggle_off,
                        size: 40,
                        color: AppColor.fond,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
