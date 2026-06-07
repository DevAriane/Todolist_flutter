import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

import '../controller/task_controller.dart';
import '../core/app_color.dart';
import '../models/task_entity.dart';
import 'app_bottom_sheet.dart';

class UpdateTask extends StatefulWidget {
  final int idTask;
  const UpdateTask({super.key, required this.idTask});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final TaskController controller = Get.find<TaskController>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  TaskEntity? _task;

  @override
  void initState() {
    super.initState();
    _task = controller.getTaskById(widget.idTask);
    _title.text = _task?.title ?? '';
    _description.text = _task?.description ?? '';
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
      _showMessage('Le titre de la tache est obligatoire.');
      return;
    }

    final isUpdated = controller.updateTaskTitle(
      widget.idTask,
      title,
      _description.text,
    );

    if (!isUpdated) {
      _showMessage("Impossible de mettre a jour la tache.");
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_task == null) {
      return const AppBottomSheet(child: Text("Cette tache n'existe plus."));
    }

    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Titre de la nouvelle tache"),
          const SizedBox(height: 10),
          TextField(
            controller: _title,
            decoration: InputDecoration(
              hintText: "EX: Lire les cahiers",
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
          const Text("Description de la nouvelle tache"),
          const SizedBox(height: 10),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "EX: Lire les cahiers",
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
