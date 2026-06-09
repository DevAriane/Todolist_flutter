import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/controller/category_controller.dart';
import 'package:todolist_flutter/controller/color_controller.dart';
import 'package:todolist_flutter/controller/date_picker_controller.dart';
import 'package:todolist_flutter/controller/person_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/utils/color_picker.dart';
import 'package:todolist_flutter/utils/date_picker_view.dart'
    show DatePickerView;

class AddTasksPage extends StatefulWidget {
  const AddTasksPage({super.key});

  @override
  State<AddTasksPage> createState() => _AddTasksPageState();
}

class _AddTasksPageState extends State<AddTasksPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.noir.withValues(alpha: 0.3),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Creer une tache",
          style: TextStyle(color: AppColor.blanc),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Entrez le titre de votre tâche",
                  style: TextStyle(color: AppColor.blanc),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _title,

                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "EX : Apprendre ObjectBox",

                    hintStyle: const TextStyle(color: Colors.white70),
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
                ),
                const SizedBox(height: 10),
                const Text(
                  "Description de votre tâche",
                  style: TextStyle(color: AppColor.blanc),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _description,
                  maxLines: 3,

                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "EX : Terminer l'intégration ObjectBox",
                    hintStyle: const TextStyle(color: Colors.white70),
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
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sélectionner une catégorie",
                  style: TextStyle(color: AppColor.blanc),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final categories = control.categories;
                  final hasSelectedCategory = categories.any(
                    (category) => category.id == _selectedCategoryId,
                  );

                  return DropdownButtonFormField<int>(
                    initialValue: hasSelectedCategory
                        ? _selectedCategoryId
                        : null,
                    hint: const Text(
                      "Sélectionner une catégorie",
                      style: TextStyle(color: AppColor.blanc),
                    ),
                    isExpanded: true,
                    dropdownColor: Colors.black,
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
                            child: Text(
                              category.name,
                              style: const TextStyle(color: AppColor.blanc),
                            ),
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
                const Text(
                  "Sélectionner une personne",
                  style: TextStyle(color: AppColor.blanc),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final persons = person.persons;
                  final hasSelectedPerson = persons.any(
                    (person) => person.id == _selectedPersonId,
                  );

                  return DropdownButtonFormField<int>(
                    initialValue: hasSelectedPerson ? _selectedPersonId : null,
                    hint: const Text(
                      "Sélectionner une personne",
                      style: TextStyle(color: AppColor.blanc),
                    ),
                    isExpanded: true,
                    dropdownColor: Colors.black,
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
                            child: Text(
                              person.name,
                              style: const TextStyle(color: AppColor.blanc),
                            ),
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
                const Text(
                  "Choisir la couleur de votre tâche",
                  style: TextStyle(color: AppColor.blanc),
                ),
                const SizedBox(height: 10),
                ColorsPicker(),
                const SizedBox(height: 10),
                DatePickerView(),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColor.blanc,
                      foregroundColor: AppColor.noir,
                    ),
                    onPressed: _submit,
                    child: const Text(
                      "Valider",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
