import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/image_ressource.dart';
import 'package:todolist_flutter/presentation/pages/home_view.dart';
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
      backgroundColor: AppColor.backg,
      appBar: AppBar(
        backgroundColor: AppColor.backg,
        actionsPadding: const EdgeInsets.all(20),
        leading: GestureDetector(
          onTap: () {
            Get.to(() => const HomeView());
          },
          child: Image.asset(ImageRessource.back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
