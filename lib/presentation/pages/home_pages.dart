import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../global_widget/search_bar.dart';
import '../../global_widget/categories.dart';
import '../../global_widget/tasks.dart';
import '../../global_widget/horizontal_date_picker.dart';
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Searchbars(),
                const SizedBox(height: 10),
                const HorizontalDatePicker(),
                const SizedBox(height: 10),
                Categories(),
                const SizedBox(height: 10),
                const Text(
                  "Tâches à effectuer",
                  style: TextStyle(color: AppColor.blanc),
                ),
                const SizedBox(height: 10),
                Tasks(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
