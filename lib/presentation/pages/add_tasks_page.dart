import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist_flutter/controller/navigation_controller.dart';
import 'package:todolist_flutter/global_widget/date_picker_widget.dart';
import 'package:todolist_flutter/global_widget/textfield_widget.dart';
import '../../feature/tasks/controllers/task_controller.dart';
import '../../feature/tasks/controllers/category_controller.dart';
import '../../feature/tasks/controllers/person_controller.dart';
import '../../controller/color_controller.dart';
import '../../utils/color_picker.dart';
import '../../core/app_color.dart';
import '../../global_widget/create_person.dart';
import '../../global_widget/heure_widget.dart';

class AddTasksPage extends StatefulWidget {
  const AddTasksPage({super.key});

  @override
  State<AddTasksPage> createState() => _AddTasksPageState();
}

class _AddTasksPageState extends State<AddTasksPage>
    with SingleTickerProviderStateMixin {
  final TaskController taskController = Get.find<TaskController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final PersonController personController = Get.find<PersonController>();
  final ColorController colorController = Get.find<ColorController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _remindMe = false;
  int? _selectedCategoryId;
  int? _selectedPersonId;
  File? _photoFile;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    final now = TimeOfDay.now();
    _startTime = now;
    _endTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _linkController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = (_selectedDate != null && _selectedDate!.isAfter(now))
        ? _selectedDate!
        : now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      if (_selectedDate != null &&
          _selectedDate!.year == now.year &&
          _selectedDate!.month == now.month &&
          _selectedDate!.day == now.day) {
        final currentMinutes = now.hour * 60 + now.minute;
        final pickedMinutes = picked.hour * 60 + picked.minute;
        if (pickedMinutes < currentMinutes) {
          _showError('L\'heure de début est déjà passée !');
          return;
        }
      }
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      if (_selectedDate != null &&
          _selectedDate!.year == now.year &&
          _selectedDate!.month == now.month &&
          _selectedDate!.day == now.day) {
        final currentMinutes = now.hour * 60 + now.minute;
        final pickedMinutes = picked.hour * 60 + picked.minute;
        if (pickedMinutes < currentMinutes) {
          _showError('L\'heure de fin est déjà passée !');
          return;
        }
      }
      if (_startTime != null) {
        final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
        final endMinutes = picked.hour * 60 + picked.minute;
        if (endMinutes <= startMinutes) {
          _showError('L\'heure de fin doit être après l\'heure de début !');
          return;
        }
      }
      setState(() => _endTime = picked);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _photoFile = File(pickedFile.path));
  }

  void _resetForm() {
    _titleController.clear();
    _descController.clear();
    _linkController.clear();
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
      Get.snackbar(
        "Champ manquant",
        "Veuillez entrer un titre",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (_selectedCategoryId == null) {
      Get.snackbar(
        "Catégorie manquante",
        "Veuillez sélectionner une catégorie",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (_selectedPersonId == null) {
      Get.snackbar(
        "Personne manquante",
        "Veuillez sélectionner une personne",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
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
      Get.snackbar(
        "Succès",
        "Tâche créée avec succès !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        final navigationController = Get.find<NavigationController>();
        navigationController.changeIndex(1);
      });
    } else {
      Get.snackbar(
        "Erreur",
        "Erreur lors de la création de la tâche",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Nouvelle tâche',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Titre', Icons.title),
              const SizedBox(height: 8),
              TextfieldWidget(
                controller: _titleController,
                name: "Ex: Lecture de livre",
                line: 1,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(
                'Description (optionnelle)',
                Icons.description,
              ),
              const SizedBox(height: 8),
              TextfieldWidget(
                controller: _descController,
                name: "Décrivez votre tâche en quelques mots...",
                line: 3,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Date', Icons.calendar_today),
              const SizedBox(height: 8),
              DatePickerWidget(
                selectedDate: _selectedDate,
                onDateSelected: (newDate) =>
                    setState(() => _selectedDate = newDate),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Horaires', Icons.access_time),
              const SizedBox(height: 8),
              HeureWidget(
                pickStartTime: _pickStartTime,
                startTime: _startTime,
                pickEndTime: _pickEndTime,
                endTime: _endTime,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Me rappeler', Icons.notifications_active),
                  Switch(
                    value: _remindMe,
                    onChanged: (val) => setState(() => _remindMe = val),
                    activeThumbColor: AppColor.or,
                    activeTrackColor: AppColor.or.withValues(alpha: 0.4),
                    inactiveThumbColor: Colors.grey[400],
                    inactiveTrackColor: Colors.grey[700],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Catégorie', Icons.category),
              const SizedBox(height: 8),
              Obx(() {
                final categories = categoryController.categories;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((cat) {
                    final isSelected = _selectedCategoryId == cat.id;
                    return ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(
                          () => _selectedCategoryId = selected ? cat.id : null,
                        );
                      },
                      backgroundColor: Colors.grey[800],
                      selectedColor: AppColor.or,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColor.noir : AppColor.blanc,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      avatar: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: AppColor.noir,
                            )
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 24),

              _buildSectionTitle('Attribuer à une personne', Icons.person),
              const SizedBox(height: 8),
              Obx(() {
                final persons = personController.persons;
                if (persons.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aucune personne disponible',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
                              setState(
                                () => _selectedPersonId =
                                    personController.persons.last.id,
                              );
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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColor.or,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.bordure),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: persons.map((person) {
                    return DropdownMenuItem<int>(
                      value: person.id,
                      child: Text(person.name),
                    );
                  }).toList(),
                  onChanged: (newId) =>
                      setState(() => _selectedPersonId = newId),
                );
              }),
              const SizedBox(height: 24),

              _buildSectionTitle('Couleur de la tâche', Icons.palette),
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
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(() {
                    final selectedColor = colorController.selectedColor.value;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: selectedColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 24,
                        color: selectedColor.computeLuminance() > 0.5
                            ? Colors.black87
                            : Colors.white,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Lien (optionnel)', Icons.link),
              const SizedBox(height: 8),
              TextField(
                controller: _linkController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'www.castbox.com',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColor.or, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColor.bordure),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Photo (optionnelle)', Icons.photo),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickPhoto,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColor.bordure,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _photoFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
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
                              'Ajouter votre photo',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.or,
                    foregroundColor: AppColor.noir,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: AppColor.or.withValues(alpha: 0.4),
                  ),
                  child: const Text(
                    'Créer la tâche',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.noir,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColor.or, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
