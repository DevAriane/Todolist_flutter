import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import '../controller/date_picker_controller.dart';

class DatePickerView extends StatelessWidget {
  DatePickerView({super.key});

  final DatePickerController controller = Get.find<DatePickerController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Text(
            controller.selectedDate.value == null
                ? 'Aucune date sélectionnée'
                : 'Date : ${controller.selectedDate.value.toString().split(' ').first}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.chooseDate(),
          child: const Text('Choisir une date'),
        ),
      ],
    );
  }
}
