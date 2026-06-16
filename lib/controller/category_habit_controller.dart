import 'package:flutter/foundation.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'package:todolist_flutter/models/category_habit_entity.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/task_entity.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';

class CategoryHabitController extends GetxController {
  final CategoriesHabit = <CategoryHabitEntity>[].obs;
  
}
