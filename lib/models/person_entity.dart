import '../feature/tasks/data/task_entity.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PersonEntity {
  @Id()
  int id = 0;
  String name;

  @Backlink('person')
  final tasks = ToMany<TaskEntity>();

  PersonEntity({required this.name});

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(name: json['name'] ?? 'Inconnu');
  }
}
