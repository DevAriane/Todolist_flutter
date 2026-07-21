import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/feature/habits/controllers/category_habit_controller.dart';
import 'package:todolist_flutter/feature/habits/controllers/habit_controller.dart';
import 'package:todolist_flutter/global_widget/app_bottom_sheet.dart';
import 'package:todolist_flutter/global_widget/date_picker_widget.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/global_widget/textfield_widget.dart';

class CreateHabit extends StatefulWidget {
  const CreateHabit({super.key});

  @override
  State<CreateHabit> createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit> {
  int? _selectedCategoryId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 21));

  final HabitController _habitController = Get.find<HabitController>();
  final CategoryHabitController _categoryHabitController =
      Get.find<CategoryHabitController>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    if (_title.text.trim().isEmpty) {
      Get.snackbar(
        "Champ requis",
        "Veuillez donner un titre à votre projet",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      Get.snackbar(
        "Sélection requise",
        "Veuillez choisir une catégorie pour votre projet",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    final success = _habitController.addHabits(
      title: _title.text.trim(),
      description: _description.text.trim(),
      categoryHabitId: _selectedCategoryId!,
      startDate: _startDate,
      endDate: _endDate,
    );

    if (success) {
      Get.back();
      Get.snackbar(
        "Succès",
        "Votre projet a été créé avec succès !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            _buildSectionHeader(
              Icons.title,
              "Entrez le titre de votre projet :",
            ),
            const SizedBox(height: 8),
            TextfieldWidget(
              controller: _title,
              name: "Ex: Analyse de la base de données",
            ),
            const SizedBox(height: 18),
            _buildSectionHeader(
              Icons.description_outlined,
              "Entrez la description de votre projet :",
            ),
            const SizedBox(height: 8),
            TextfieldWidget(
              controller: _description,
              name: "Décrivez brièvement les objectifs du projet...",
              line: 3,
            ),
            const SizedBox(height: 18),
            _buildSectionHeader(
              Icons.calendar_today_outlined,
              "Sélectionnez les dates de début et de fin :",
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DatePickerWidget(
                    selectedDate: _startDate,
                    onDateSelected: (date) {
                      setState(() {
                        _startDate = date;
                        if (_endDate.isBefore(_startDate)) {
                          _endDate = _startDate;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DatePickerWidget(
                    selectedDate: _endDate,
                    onDateSelected: (date) {
                      setState(() {
                        if (date.isAfter(_startDate) ||
                            date.isAtSameMomentAs(_startDate)) {
                          _endDate = date;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildSectionHeader(
              Icons.category_outlined,
              "Choisissez la catégorie de votre projet :",
            ),
            const SizedBox(height: 10),
            Obx(() {
              final categories = _categoryHabitController.categoriesHabit;
              if (categories.isEmpty) {
                return const Text(
                  "Aucune catégorie disponible",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                );
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = _selectedCategoryId == cat.id;
                  return ChoiceChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = selected ? cat.id : null;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppColor.or,
                    elevation: isSelected ? 2 : 0,
                    pressElevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColor.or : Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColor.noir : Colors.grey[800],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.noir,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Créer le projet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blanc,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColor.noir.withValues(alpha: 0.7), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: TextWidget(name: title, color: AppColor.noir),
        ),
      ],
    );
  }
}
