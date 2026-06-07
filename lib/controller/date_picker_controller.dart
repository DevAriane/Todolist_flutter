import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

class DatePickerController extends GetxController {
  var selectedDate = Rxn<DateTime>();

  Future<void> chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Sélectionnez une date',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }
}
