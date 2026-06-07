import 'package:flutter/material.dart'; // Nécessaire pour la classe Color
import 'package:objectbox/objectbox.dart';
import './category_entity.dart';

@Entity()
class TaskEntity {
  @Id()
  int id = 0;
  String title;
  String? description;
  bool completed;
  DateTime? date;
  int? dbColor;

  final category = ToOne<CategoryEntity>();

  TaskEntity({
    required this.title,
    this.completed = false,
    this.description,
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
