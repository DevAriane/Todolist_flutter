import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:objectbox/objectbox.dart';
import './habit_entity.dart';

@Entity()
class CategoryHabitEntity {
  @Id()
  int id = 0;
  String name;
  int? dbColor;
  String? icon;

  @Backlink('categoryHabit')
  final habits = ToMany<HabitEntity>();

  CategoryHabitEntity({
    required this.name,
    this.dbColor,
    this.icon,
    Color? color,
  }) {
    this.color = color;
  }

  factory CategoryHabitEntity.fromJson(Map<String, dynamic> json) {
    return CategoryHabitEntity(
      name: json['name'],
      dbColor: json['color'],
      icon: json['icon'],
    );
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
