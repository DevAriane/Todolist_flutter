import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/person_controller.dart';
import '../core/app_color.dart';
import 'app_bottom_sheet.dart';

class CreatePerson extends StatefulWidget {
  const CreatePerson({super.key});

  @override
  State<CreatePerson> createState() => _CreatePersonState();
}

class _CreatePersonState extends State<CreatePerson> {
  final PersonController controller = Get.find<PersonController>();
  final TextEditingController _namePerson = TextEditingController();

  @override
  void dispose() {
    _namePerson.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    final name = _namePerson.text.trim();
    if (name.isEmpty) {
      _showMessage('Le nom de la personne est obligatoire.');
      return;
    }

    final isSaved = controller.addPerson(name);
    if (!isSaved) {
      _showMessage('Cette personne existe déjà ou le nom est invalide.');
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
            "Entrez le nom de la personne",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _namePerson,
            decoration: InputDecoration(
              hintText: "EX : Claire",
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
