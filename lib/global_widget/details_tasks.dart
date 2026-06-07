import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

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
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(task.description ?? ""),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Completer la tache", style: TextStyle(fontSize: 16)),
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
