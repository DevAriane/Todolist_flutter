import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/global_widget/app_bottom_sheet.dart';
import 'package:todolist_flutter/global_widget/date_picker_widget.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/global_widget/textfield_widget.dart';
import 'package:todolist_flutter/presentation/navigation_page.dart';
import '../controller/habit_controller.dart';
import '../controller/category_habit_controller.dart';

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
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            name: "Entrez le titre de votre projet :",
            color: AppColor.noir,
          ),
          const SizedBox(height: 10),
          TextfieldWidget(
            controller: _title,
            name: "Analyse de la base de donnee",
          ),
          const SizedBox(height: 10),
          const TextWidget(
            name: "Entrez la description de votre projet  :",
            color: AppColor.noir,
          ),
          const SizedBox(height: 10),
          TextfieldWidget(
            controller: _description,
            name: "Analyse de la base de donnee....",
            line: 3,
          ),
          const SizedBox(height: 10),
          const TextWidget(
            name: "Sélectionnez les dates de début et de fin",
            color: AppColor.noir,
          ),
          const SizedBox(height: 10),
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
              const SizedBox(width: 10),
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
          const SizedBox(height: 10),
          const TextWidget(
            name: "Choississez la categorie de votre projet :",
            color: AppColor.noir,
          ),
          Obx(() {
            final categories = _categoryHabitController.categoriesHabit;
            return Wrap(
              spacing: 10,
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
                  backgroundColor: Colors.grey[800],
                  selectedColor: AppColor.or,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColor.noir : AppColor.blanc,
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_title.text.trim().isEmpty || _selectedCategoryId == null)
                  return;

                final success = _habitController.addHabits(
                  title: _title.text,
                  description: _description.text,
                  categoryHabitId: _selectedCategoryId!,
                  startDate: _startDate,
                  endDate: _endDate,
                );

                if (success) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.noir,
                foregroundColor: AppColor.noir,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Créer le projet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blanc,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
