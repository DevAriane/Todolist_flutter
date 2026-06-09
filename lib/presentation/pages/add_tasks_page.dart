import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../controller/task_controller.dart';
import '../../controller/category_controller.dart';
import '../../controller/person_controller.dart';
import '../../controller/color_controller.dart'; // ← Ajout
import '../../utils/color_picker.dart'; // ← pour showColorPickerDialog
import '../../core/app_color.dart';

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
      Get.back();
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
          'Create New Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            const Text('Title', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Book reading',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date
            const Text('Date', style: TextStyle(color: Colors.white70)),
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
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                          : 'Select date',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time range
            const Text('Time', style: TextStyle(color: Colors.white70)),
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
                      ),
                      child: Text(
                        _startTime != null
                            ? _startTime!.format(context)
                            : 'Start',
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
                      ),
                      child: Text(
                        _endTime != null ? _endTime!.format(context) : 'End',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Remind me
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Remind me',
                  style: TextStyle(color: Colors.white70),
                ),
                Switch(
                  value: _remindMe,
                  onChanged: (val) => setState(() => _remindMe = val),
                  activeThumbColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category
            const Text('Category', style: TextStyle(color: Colors.white70)),
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
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 20),

            // Person
            const Text(
              'Assign to person',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final persons = personController.persons;
              return DropdownButtonFormField<int>(
                initialValue: _selectedPersonId,
                hint: const Text(
                  'Select a person',
                  style: TextStyle(color: Colors.white70),
                ),
                isExpanded: true,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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

            // Choisir la couleur (dialog)
            const Text(
              'Choose task color',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showColorPickerDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pick a color'),
              ),
            ),
            // Aperçu de la couleur sélectionnée
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
                    'Selected color',
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

            const SizedBox(height: 20),

            // Description
            const Text(
              'Description (Optional)',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText:
                    'After completing a design project, I have to read 60 pages...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Link
            const Text(
              'Link (Optional)',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _linkController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'www.castbox.com',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Add photo
            const Text(
              'Add photo (Optional)',
              style: TextStyle(color: Colors.white70),
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
                  border: Border.all(color: Colors.grey[700]!),
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
                          Text(
                            'Enter your photo',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 30),

            // Create task button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
