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

  @Index()
  String? titleNormalized;

  final categoryHabit = ToOne<CategoryHabitEntity>();

  HabitEntity({
    required this.title,
    this.decription,
    required this.startDate,
    required this.endDate,
    required this.isCompletedToday,
    this.titleNormalized,
  });

  factory HabitEntity.fromJson(Map<String, dynamic> json) {
    return HabitEntity(
      title: json['title'] ?? "",
      decription: json['description'] ?? "",
      startDate: json['startDate'] ?? "",
      endDate: json['endDate'] ?? "",
      isCompletedToday: json['isCompletedToday'] ?? false,
      titleNormalized: json['title'] ?? "",
    );
  }
}
