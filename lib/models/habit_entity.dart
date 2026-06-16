import 'package:objectbox/objectbox.dart'; 
import 'package:todolist_flutter/models/category_habit_entity.dart';

@Entity()
class HabitEntity {
  @Id()
  int id = 0;
  final String title;
  final String? decription;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompletedToday;

  final categoryHabit = ToOne<CategoryHabitEntity>();

  HabitEntity({
    required this.title,
    this.decription,
    required this.startDate,
    required this.endDate,
    required this.isCompletedToday,
  });
}
