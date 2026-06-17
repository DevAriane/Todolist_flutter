import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/global_widget/icon_list.dart';
import 'package:todolist_flutter/global_widget/icon_picker.dart';
import '../controller/category_habit_controller.dart';
import '../core/app_color.dart';
import 'app_bottom_sheet.dart';
import '../utils/color_picker.dart';
import '../controller/color_controller.dart';

class CreateCategoryHabit extends StatefulWidget {
  const CreateCategoryHabit({super.key});

  @override
  State<CreateCategoryHabit> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategoryHabit> {
  final ColorController _colorController = Get.find<ColorController>();
  final CategoryHabitController controller =
      Get.find<CategoryHabitController>();
  final TextEditingController _nameCategory = TextEditingController();

  String? _selectedIcon;

  @override
  void dispose() {
    _nameCategory.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    final name = _nameCategory.text.trim();
    if (name.isEmpty) {
      _showMessage('Le nom de la catégorie est obligatoire.');
      return;
    }

    final isSaved = controller.addCategoryHabit(name, _selectedIcon);
    if (!isSaved) {
      _showMessage('Cette catégorie existe déjà ou le nom est invalide.');
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Entrez le nom de la catégorie",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameCategory,
              decoration: InputDecoration(
                hintText: "EX : Études",
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
              'Choisir la couleur',
              style: TextStyle(color: AppColor.blanc),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => showColorPickerDialog(context),
                    icon: const Icon(Icons.palette_outlined, size: 18),
                    label: const Text('Choisir une couleur'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(() {
                  final selectedColor = _colorController.selectedColor.value;
                  return Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: selectedColor.withAlpha((0.3 * 255).toInt()),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: selectedColor.computeLuminance() > 0.5
                          ? Colors.black87
                          : Colors.white,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),
            IconPicker(
              initialIcon: _selectedIcon,
              onIconSelected: (iconName) {
                setState(() {
                  _selectedIcon = iconName.isNotEmpty ? iconName : null;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColor.noir,
                  foregroundColor: AppColor.blanc,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }
}
