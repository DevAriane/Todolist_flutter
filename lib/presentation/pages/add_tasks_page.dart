import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todolist_flutter/presentation/pages/home_pages.dart';
import '../../controller/task_controller.dart';
import '../../controller/category_controller.dart';
import '../../controller/person_controller.dart';
import '../../controller/color_controller.dart';
import '../../utils/color_picker.dart';
import '../../core/app_color.dart';
import '../../global_widget/create_person.dart';

class AddTasksPage extends StatefulWidget {
  const AddTasksPage({super.key});

  @override
  State<AddTasksPage> createState() => _AddTasksPageState();
}

class _AddTasksPageState extends State<AddTasksPage> {
  final TaskController taskController = Get.find<TaskController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final PersonController personController = Get.find<PersonController>();
  final ColorController colorController = Get.find<ColorController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _remindMe = false;
  int? _selectedCategoryId;
  int? _selectedPersonId;
  File? _photoFile;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    final now = TimeOfDay.now();
    _startTime = now;
    _endTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);
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
      initialDate: _selectedDate!,
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

  void _resetForm() {
    _titleController.clear();
    _descController.clear();
    _linkController.clear();
    _tagController.clear();

    setState(() {
      _selectedDate = DateTime.now();
      final now = TimeOfDay.now();
      _startTime = now;
      _endTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);
      _remindMe = false;
      _selectedCategoryId = null;
      _selectedPersonId = null;
      _photoFile = null;
    });
  }

  void _createTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Veuillez entrer un titre')));
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une catégorie')),
      );
      return;
    }
    if (_selectedPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une personne')),
      );
      return;
    }

    final success = taskController.addTask(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      date: _selectedDate,
      startTime: _startTime?.format(context),
      endTime: _endTime?.format(context),
      remindMe: _remindMe,
      link: _linkController.text.trim().isEmpty
          ? null
          : _linkController.text.trim(),
      photoPath: _photoFile?.path,
      categoryId: _selectedCategoryId!,
      personId: _selectedPersonId!,
      color: colorController.selectedColor.value,
    );

    if (success) {
      _resetForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tâche créée avec succès !')),
      );

      Get.to(() => HomePages());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Créer une nouvelle tâche',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Titre', style: TextStyle(color: AppColor.blanc)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColor.blanc),
              decoration: InputDecoration(
                hintText: 'Lecture de livre',
                hintStyle: const TextStyle(color: AppColor.placeholder),
                filled: true,
                fillColor: Colors.grey[900],
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.white60),
                ),

                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: AppColor.bordure),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description (Optionnelle)',
              style: TextStyle(color: AppColor.blanc),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText:
                    'Après avoir terminé un projet de design, je dois lire 60 pages...',
                hintStyle: const TextStyle(color: AppColor.placeholder),
                filled: true,
                fillColor: Colors.grey[900],
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.white60),
                ),

                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: AppColor.bordure),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text('Date', style: TextStyle(color: AppColor.blanc)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.bordure),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                          : 'Sélectionner une date',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Heure', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickStartTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.bordure),
                      ),
                      child: Text(
                        _startTime != null
                            ? _startTime!.format(context)
                            : 'Début',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('—', style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickEndTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.bordure),
                      ),
                      child: Text(
                        _endTime != null ? _endTime!.format(context) : 'Fin',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Me rappeler',
                  style: TextStyle(color: AppColor.blanc),
                ),
                Switch(
                  value: _remindMe,
                  onChanged: (val) => setState(() => _remindMe = val),
                  activeThumbColor: AppColor.or,
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Catégorie', style: TextStyle(color: AppColor.blanc)),
            const SizedBox(height: 8),
            Obx(() {
              final categories = categoryController.categories;
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

            const Text(
              'Attribuer à une personne',
              style: TextStyle(color: AppColor.blanc),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final persons = personController.persons;

              if (persons.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aucune personne disponible',
                      style: TextStyle(color: AppColor.blanc),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Get.bottomSheet(
                            const CreatePerson(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enableDrag: true,
                          );

                          if (personController.persons.isNotEmpty) {
                            setState(() {
                              _selectedPersonId =
                                  personController.persons.last.id;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: AppColor.noir,
                        ),
                        label: const Text('Créer une personne'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.blanc,
                          foregroundColor: AppColor.noir,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return DropdownButtonFormField<int>(
                initialValue: _selectedPersonId,
                hint: const Text(
                  'Sélectionner une personne',
                  style: TextStyle(color: AppColor.blanc),
                ),
                isExpanded: true,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColor.bordure),
                  ),
                ),
                items: persons.map((person) {
                  return DropdownMenuItem<int>(
                    value: person.id,
                    child: Text(person.name),
                  );
                }).toList(),
                onChanged: (newId) {
                  setState(() {
                    _selectedPersonId = newId;
                  });
                },
              );
            }),
            const SizedBox(height: 20),

            const Text(
              'Choisir la couleur de la tâche',
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
                  final selectedColor = colorController.selectedColor.value;
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

            const SizedBox(height: 20),

            const Text(
              'Lien (Optionnel)',
              style: TextStyle(color: AppColor.blanc),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _linkController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'www.castbox.com',
                hintStyle: const TextStyle(color: AppColor.placeholder),
                filled: true,
                fillColor: Colors.grey[900],
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.white60),
                ),

                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: AppColor.bordure),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Ajouter une photo (Optionnelle)',
              style: TextStyle(color: AppColor.blanc),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.bordure),
                ),
                child: _photoFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_photoFile!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey[500],
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ajouter votre photo',
                            style: TextStyle(color: AppColor.blanc),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.blanc,
                  foregroundColor: AppColor.noir,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Créer la tâche',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.noir,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
