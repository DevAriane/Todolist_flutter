import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/global_widget/icon_list.dart';
import 'habit_entity.dart';

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
      name: json['name'] ?? '',
      dbColor: json['dbColor'],
      icon: json['icon'],
    );
  }

  @Transient()
  Color? get color {
    if (dbColor == null) return null;

    return Color(dbColor!.toSigned(32));
  }

  set color(Color? newColor) {
    if (newColor == null) {
      dbColor = null;
    } else {
      dbColor = newColor.toARGB32();
    }
  }

  @Transient()
  IconData get iconData => getIconData(icon);
}
