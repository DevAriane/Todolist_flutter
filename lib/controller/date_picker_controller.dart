import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

class DatePickerController extends GetxController {
  var selectedDate = Rxn<DateTime>();

  Future<void> chooseDate(BuildContext context) async {
    final maintenant = DateTime.now();
    final aujourdHui = DateTime(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );

    DateTime dateInitiale = selectedDate.value ?? aujourdHui;
    if (dateInitiale.isBefore(aujourdHui)) {
      dateInitiale = aujourdHui;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateInitiale,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(aujourdHui) || day.isAtSameMomentAs(aujourdHui);
      },
      helpText: 'Sélectionnez une date',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (pickedDate != null && pickedDate.isBefore(aujourdHui)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous ne pouvez pas choisir une date passée'),
        ),
      );
      return;
    }

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }
}
