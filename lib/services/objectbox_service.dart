import 'package:path_provider/path_provider.dart';
import 'package:todolist_flutter/objectbox.g.dart';

import '../models/category_entity.dart';
import '../models/task_entity.dart';
import '../models/person_entity.dart';
import '../feature/habits/data/models/habit_entity.dart';
import '../feature/habits/data/models/category_habit_entity.dart';
import '../models/user_model.dart';
import '../models/todo.dart';

class ObjectBoxService {
  static late Store store;
  static late Box<TaskEntity> taskBox;
  static late Box<CategoryEntity> categoryBox;
  static late Box<PersonEntity> personBox;
  static late Box<HabitEntity> habitBox;
  static late Box<CategoryHabitEntity> categoryHabitBox;
  static late Box<UserModel> userBox;
  static late Box<Todo> todoBox;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    store = Store(getObjectBoxModel(), directory: dir.path);
    taskBox = store.box<TaskEntity>();
    categoryBox = store.box<CategoryEntity>();
    personBox = store.box<PersonEntity>();
    categoryHabitBox = store.box<CategoryHabitEntity>();
    habitBox = store.box<HabitEntity>();
    userBox = store.box<UserModel>();
    todoBox = store.box<Todo>();
  }
}
