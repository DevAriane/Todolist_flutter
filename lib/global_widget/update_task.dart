import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controller/task_controller.dart';
import '../core/app_color.dart';
import '../models/task_entity.dart';
import 'app_bottom_sheet.dart';
import '../controller/category_controller.dart';
import '../controller/color_controller.dart';
import '../controller/person_controller.dart';
import '../utils/color_picker.dart';

class UpdateTask extends StatefulWidget {
  final int idTask;
  const UpdateTask({super.key, required this.idTask});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final TaskController controller = Get.find<TaskController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final PersonController personController = Get.find<PersonController>();
  final ColorController colorController = Get.find<ColorController>();

  late TaskEntity _task;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  // État
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _remindMe = false;
  int? _selectedCategoryId;
  int? _selectedPersonId;
  File? _photoFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final task = controller.getTaskById(widget.idTask);
    if (task == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tâche introuvable')));
        Navigator.pop(context);
      });
      return;
    }
    _task = task;

    _titleController.text = _task.title;
    _descController.text = _task.description ?? '';
    _selectedDate = _task.date;
    _startTime = _task.startTime != null
        ? _parseTimeOfDay(_task.startTime!)
        : TimeOfDay.now();
    _endTime = _task.endTime != null
        ? _parseTimeOfDay(_task.endTime!)
        : TimeOfDay(hour: _startTime!.hour + 1, minute: _startTime!.minute);
    _remindMe = _task.remindMe;
    _selectedCategoryId = _task.category.target?.id;
    _selectedPersonId = _task.person.target?.id;
    _linkController.text = _task.link ?? '';
    if (_task.photoPath != null && File(_task.photoPath!).existsSync()) {
      _photoFile = File(_task.photoPath!);
    }
    colorController.changeColor(_task.color ?? Colors.blue);
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _linkController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime!,
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime!,
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _photoFile = File(pickedFile.path));
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showMessage('Le titre est obligatoire');
      return;
    }
    if (_selectedCategoryId == null) {
      _showMessage('Veuillez sélectionner une catégorie');
      return;
    }
    if (_selectedPersonId == null) {
      _showMessage('Veuillez sélectionner une personne');
      return;
    }

    setState(() => _isLoading = true);

    final success = controller.updateTaskTitle(
      widget.idTask,
      title,
      _descController.text.trim(),
      _selectedCategoryId!,
      _selectedPersonId!,
      colorController.selectedColor.value,
      _selectedDate,
      _startTime?.format(context),
      _endTime?.format(context),
      _remindMe,
      _linkController.text.trim().isEmpty ? null : _linkController.text.trim(),
      _photoFile?.path,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      _showMessage('Erreur lors de la mise à jour');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AppBottomSheet(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AppBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Titre', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Titre de la tâche',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.bordure),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                          : 'Sélectionner une date',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Heure', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickStartTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.bordure),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_startTime?.format(context) ?? 'Début'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('—'),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickEndTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.bordure),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_endTime?.format(context) ?? 'Fin'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Me rappeler',
                  style: TextStyle(
                    color: AppColor.noir,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _remindMe,
                  onChanged: (val) => setState(() => _remindMe = val),
                  activeThumbColor: AppColor.or,
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Catégorie',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final categories = categoryController.categories;
              return DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                hint: const Text('Choisir une catégorie'),
                isExpanded: true,
                items: categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (id) => setState(() => _selectedCategoryId = id),
              );
            }),
            const SizedBox(height: 16),

            const Text(
              'Personne',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final persons = personController.persons;
              return DropdownButtonFormField<int>(
                initialValue: _selectedPersonId,
                hint: const Text('Choisir une personne'),
                isExpanded: true,
                items: persons.map((p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (id) => setState(() => _selectedPersonId = id),
              );
            }),
            const SizedBox(height: 8),

            const Text(
              'Choisir la couleur de la tâche',
              style: TextStyle(color: AppColor.noir),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showColorPickerDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.noir,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Choisir une couleur',
                  style: TextStyle(color: AppColor.blanc),
                ),
              ),
            ),

            Obx(
              () => Container(
                margin: const EdgeInsets.only(top: 8),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorController.selectedColor.value,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Couleur sélectionnée',
                    style: TextStyle(
                      color:
                          colorController.selectedColor.value
                                  .computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lien (optionnel)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                hintText: 'https://...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Photo (optionnelle)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.bordure),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _photoFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_photoFile!, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Text('Appuyer pour ajouter une photo'),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColor.noir),
                ),
                onPressed: _submit,
                child: const Text(
                  'Mettre à jour',
                  style: TextStyle(
                    color: AppColor.blanc,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
