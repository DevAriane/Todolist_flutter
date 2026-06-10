import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'category_entity.dart';
import 'person_entity.dart';

@Entity()
class TaskEntity {
  @Id()
  int id = 0;
  String title;
  String? description;
  bool completed;

  @Property(type: PropertyType.date)
  DateTime? date;

  String? startTime;
  String? endTime;

  bool remindMe;
  String? link;
  String? photoPath;

  int? dbColor;

  @Index()
  String? titleNormalized;

  final category = ToOne<CategoryEntity>();
  final person = ToOne<PersonEntity>();

  TaskEntity({
    required this.title,
    this.completed = false,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.remindMe = false,
    this.link,
    this.photoPath,
    this.titleNormalized,
    Color? color,
  }) {
    this.color = color;
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    final task = TaskEntity(
      title: json['title'] ?? 'Sans titre',
      completed: json['completed'] ?? false,
      description: json['description'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      remindMe: json['remindMe'] ?? false,
      link: json['link'],
      photoPath: json['photoPath'],
      titleNormalized: json['title'] != null
          ? (json['title'] as String).toLowerCase()
          : null,
    );
    
    if (json['dbColor'] != null) {
      task.dbColor = int.parse(json['dbColor'].toString());
    }
    
    return task;
  }

  @Transient()
  Color? get color {
    if (dbColor == null) return null;
    return Color(dbColor!);
  }

  set color(Color? newColor) {
    if (newColor == null) {
      dbColor = null;
    } else {
      dbColor = newColor.toARGB32();
    }
  }
}
