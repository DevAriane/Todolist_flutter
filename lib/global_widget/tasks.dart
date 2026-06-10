import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import '../core/app_color.dart';
import '../controller/task_controller.dart';
import './update_task.dart';
import './details_tasks.dart';

class Tasks extends StatelessWidget {
  Tasks({super.key});

  final TaskController controller = Get.find<TaskController>();

  String _getMonthName(int month) {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  Widget _buildTaskItem(BuildContext context, dynamic task) {
    final hasDate = task.date != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: task.color ?? Colors.blue,
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    showDragHandle: false,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DetailsTasks(task: task),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(color: AppColor.blanc),
                    ),
                    if (hasDate) ...[
                      const SizedBox(height: 5),
                      Text(
                        task.completed
                            ? "Complétée le ${_formatDate(task.date)}"
                            : "À faire le ${_formatDate(task.date)}",
                        style: const TextStyle(
                          color: AppColor.blanc,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (!task.completed)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => UpdateTask(idTask: task.id));
                  },
                  icon: const Icon(Icons.update),
                ),
                IconButton(
                  onPressed: () => controller.deleteTask(task),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<dynamic> sectionTasks,
  ) {
    if (sectionTasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColor.or,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sectionTasks.length,
          itemBuilder: (context, index) =>
              _buildTaskItem(context, sectionTasks[index]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final allTasks = controller.displayedTasks;
      if (allTasks.isEmpty) {
        final selectedDate = controller.selectedFilterDate.value;
        final formattedDate = _formatDate(selectedDate);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 64, color: AppColor.blanc),
              const SizedBox(height: 16),
              Text(
                'Vous n\'avez pas de tâche pour le $formattedDate',
                style: const TextStyle(color: AppColor.blanc, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      final pendingTasks = allTasks
          .where((task) => task.completed == false)
          .toList();
      final completedTasks = allTasks
          .where((task) => task.completed == true)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(context, "En cours ...", pendingTasks),
          _buildSection(context, "Terminées", completedTasks),
        ],
      );
    });
  }
}
