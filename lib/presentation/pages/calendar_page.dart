import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/task_controller.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key});
  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // children: [
          //   Text("Tach a effetuer par par odre de jour"),
          //   HorizontalDatePicker(),

          // ],
        ),
      ),
    );
  }
}
