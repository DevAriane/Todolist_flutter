import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/feature/habits/data/models/category_habit_entity.dart';

@Entity()
class HabitEntity {
  @Id()
  int id = 0;
  final String title;
  final String? decription;
  final DateTime startDate;
  final DateTime endDate;

  List<String> completedDates = [];

  @Index()
  String? titleNormalized;

  final categoryHabit = ToOne<CategoryHabitEntity>();

  HabitEntity({
    required this.title,
    this.decription,
    required this.startDate,
    required this.endDate,
    this.completedDates = const [],
    this.titleNormalized,
  });

  int get totalDaysChallenge {
    return endDate.difference(startDate).inDays + 1;
  }

  int get completedDaysCount => completedDates.length;

  double get progressRatio {
    if (totalDaysChallenge <= 0) return 0.0;
    final ratio = completedDaysCount / totalDaysChallenge;
    return ratio.clamp(0.0, 1.0);
  }

  bool get isCompletedToday {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    return completedDates.contains(todayStr);
  }

  factory HabitEntity.fromJson(Map<String, dynamic> json) {
    List<String> parsedDates = [];
    if (json['completedDates'] != null) {
      parsedDates = List<String>.from(json['completedDates']);
    }

    return HabitEntity(
      title: json['title'] ?? "",
      decription: json['description'] ?? "",
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      completedDates: parsedDates,
      titleNormalized: json['title'] ?? "",
    );
  }
}
