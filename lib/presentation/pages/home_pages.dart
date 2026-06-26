import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/app_color.dart';
import '../../global_widget/categories.dart';
import '../../global_widget/tasks.dart';
import '../../global_widget/horizontal_date_picker.dart';
import '../../controller/task_controller.dart';

class HomePages extends StatelessWidget {
  HomePages({super.key});

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColor.backg,
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
      ),
    );
  }
}
