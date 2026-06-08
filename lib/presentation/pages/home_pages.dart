import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../global_widget/search_bar.dart';
import '../../global_widget/categories.dart';
import '../../global_widget/tasks.dart';
import '../../global_widget/add_task.dart';
import '../../controller/task_controller.dart';
import 'package:getxtra/get.dart';

class HomePages extends StatelessWidget {
  HomePages({super.key});

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.noir,
      appBar: AppBar(
        backgroundColor: AppColor.noir,
        actionsPadding: const EdgeInsets.all(20),
        centerTitle: true,
        title: const Text(
          "Zen List",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColor.blanc,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: const [Icon(Icons.notifications_none, color: AppColor.blanc)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bonjour, Hattie !",
                style: TextStyle(color: AppColor.blanc, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final taskCount = controller.tasks.length;
                return Text.rich(
                  TextSpan(
                    text: "Vous avez ",
                    style: const TextStyle(
                      color: AppColor.blanc,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: taskCount == 0
                            ? "aucune tâche"
                            : taskCount == 1
                            ? "1 tâche"
                            : "$taskCount tâches",
                        style: const TextStyle(
                          color: AppColor.or,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " aujourd'hui."),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              const Searchbars(),
              const SizedBox(height: 20),
              Categories(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "Tâches à effectuer",
                    style: TextStyle(color: AppColor.blanc),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        showDragHandle: false,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return const AddTask();
                        },
                      );
                    },
                    icon: const Icon(Icons.add_circle, color: AppColor.blanc),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: Tasks()),
            ],
          ),
        ),
      ),
    );
  }
}
