import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

import '../controller/category_controller.dart';
import '../core/app_color.dart';
import 'app_bottom_sheet.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final CategoryController controller = Get.find<CategoryController>();
  final TextEditingController _nameCategory = TextEditingController();

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
      _showMessage('Le nom de la categorie est obligatoire.');
      return;
    }

    final isSaved = controller.addCategory(name);
    if (!isSaved) {
      _showMessage('Cette categorie existe deja ou le nom est invalide.');
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Entrez le nom de la categorie",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameCategory,
            decoration: InputDecoration(
              hintText: "EX: Study",
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
