import 'package:path_provider/path_provider.dart';
import 'package:todolist_flutter/objectbox.g.dart';

import '../models/category_entity.dart';
import '../models/task_entity.dart';
import '../models/person_entity.dart';
import '../models/habit_entity.dart';
import '../models/category_habit_entity.dart';

class ObjectBoxService {
  static late Store store;
  static late Box<TaskEntity> taskBox;
  static late Box<CategoryEntity> categoryBox;
  static late Box<PersonEntity> personBox;
  static late Box<HabitEntity> habitBox;
  static late Box<CategoryHabitEntity> categoryHabitBox;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    store = Store(getObjectBoxModel(), directory: dir.path);
    taskBox = store.box<TaskEntity>();
    categoryBox = store.box<CategoryEntity>();
    personBox = store.box<PersonEntity>();
    categoryHabitBox = store.box<CategoryHabitEntity>();
    habitBox = store.box<HabitEntity>();
  }
}
