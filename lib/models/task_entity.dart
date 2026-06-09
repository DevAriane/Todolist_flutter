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
    List<String>? tags,
    Color? color,
  }) {
    this.color = color;
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
