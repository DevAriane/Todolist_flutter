import 'package:flutter/material.dart';
import './task_entity.dart';
import 'package:todolist_flutter/objectbox.g.dart';

@Entity()
class PersonEntity {
  @Id()
  int id = 0;
  String name;

  @Backlink('person')
  final tasks = ToMany<TaskEntity>();

  PersonEntity({required this.id, required this.name});
}
