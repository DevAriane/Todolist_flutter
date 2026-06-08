import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

import '../controller/category_controller.dart';
import '../controller/task_controller.dart';
import '../controller/color_controller.dart';
import '../controller/date_picker_controller.dart';
import '../core/app_color.dart';
import 'app_bottom_sheet.dart';
import '../utils/color_picker.dart';
import '../utils/date_picker_view.dart';
import '../controller/person_controller.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TaskController controller = Get.find<TaskController>();
  final CategoryController control = Get.find<CategoryController>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final ColorController color = Get.find<ColorController>();
  final DatePickerController date = Get.find<DatePickerController>();
  final PersonController person = Get.find<PersonController>();
  int? _selectedCategoryId;
  int? _selectedPersonId;

  @override
  void initState() {
    super.initState();
    final activeCategoryId = control.selectedCategoryId.value;
    if (activeCategoryId != 0) {
      _selectedCategoryId = activeCategoryId;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      _showMessage('Le titre de la tâche est obligatoire.');
      return;
    }

    if (_selectedCategoryId == null) {
      _showMessage('Sélectionnez une catégorie avant de valider.');
      return;
    }

    if (_selectedPersonId == null) {
      _showMessage('Sélectionnez une personne avant de valider.');
      return;
    }

    final isSaved = controller.addTask(
      title,
      _description.text,
      _selectedCategoryId!,
      _selectedPersonId!,
      color.selectedColor.value,
      date.selectedDate.value,
    );

    if (!isSaved) {
      _showMessage("Impossible d'enregistrer la tâche.");
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Entrez le titre de votre tâche"),
          const SizedBox(height: 10),
          TextField(
            controller: _title,
            decoration: InputDecoration(
              hintText: "EX : Apprendre ObjectBox",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.bordure),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.bordure, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Description de votre tâche"),
          const SizedBox(height: 10),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "EX : Terminer l'intégration ObjectBox",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.bordure),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.bordure, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Sélectionner une catégorie"),
          const SizedBox(height: 10),
          Obx(() {
            final categories = control.categories;
            final hasSelectedCategory = categories.any(
              (category) => category.id == _selectedCategoryId,
            );

            return DropdownButtonFormField<int>(
              initialValue: hasSelectedCategory ? _selectedCategoryId : null,
              hint: const Text("Sélectionner une catégorie"),
              isExpanded: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColor.bordure),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColor.bordure,
                    width: 2,
                  ),
                ),
              ),
              items: categories
                  .map(
                    (category) => DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (newId) {
                setState(() {
                  _selectedCategoryId = newId;
                });
              },
            );
          }),
          const SizedBox(height: 10),
          const Text("Sélectionner une personne"),
          const SizedBox(height: 10),
          Obx(() {
            final persons = person.persons;
            final hasSelectedPerson = persons.any(
              (person) => person.id == _selectedPersonId,
            );

            return DropdownButtonFormField<int>(
              initialValue: hasSelectedPerson ? _selectedPersonId : null,
              hint: const Text("Sélectionner une personne"),
              isExpanded: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColor.bordure),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColor.bordure,
                    width: 2,
                  ),
                ),
              ),
              items: persons
                  .map(
                    (person) => DropdownMenuItem<int>(
                      value: person.id,
                      child: Text(person.name),
                    ),
                  )
                  .toList(),
              onChanged: (newId) {
                setState(() {
                  _selectedPersonId = newId;
                });
              },
            );
          }),
          const SizedBox(height: 10),
          const Text("Choisir la couleur de votre tâche"),
          const SizedBox(height: 10),
          ColorsPicker(),
          const SizedBox(height: 10),
          DatePickerView(),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.noir,
                foregroundColor: AppColor.blanc,
              ),
              onPressed: _submit,
              child: const Text(
                "Valider",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
