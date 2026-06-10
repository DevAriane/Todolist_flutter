import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

class DatePickerController extends GetxController {
  var selectedDate = Rxn<DateTime>();

  Future<void> chooseDate() async {
    final maintenant = DateTime.now();

    final DateTime demain = DateTime(
      maintenant.year,
      maintenant.month,
      maintenant.day + 1,
    );

    DateTime dateInitiale = selectedDate.value ?? demain;
    if (dateInitiale.isBefore(demain)) {
      dateInitiale = demain;
    }

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: dateInitiale,
      firstDate: demain,
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
