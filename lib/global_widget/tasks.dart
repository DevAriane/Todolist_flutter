import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import '../core/app_color.dart';
import '../controller/task_controller.dart';
import '../controller/category_controller.dart';
import './update_task.dart';
import './details_tasks.dart';

class Tasks extends StatelessWidget {
  Tasks({super.key});

  final TaskController controller = Get.find<TaskController>();
  final CategoryController control = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value || control.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (control.taksCategories.isEmpty) {
        return const Center(child: Text("aucune tache"));
      }

      return ListView.separated(
        itemBuilder: (context, index) {
          final task = control.taksCategories[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    showDragHandle: false,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return DetailsTasks(task: task);
                    },
                  );
                },
                child: Text(
                  task.title,
                  style: const TextStyle(color: AppColor.blanc),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        showDragHandle: false,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return UpdateTask(idTask: task.id);
                        },
                      );
                    },
                    icon: const Icon(Icons.update),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.deleteTask(task);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: control.taksCategories.length,
      );
    });
  }
}
