import 'package:objectbox/objectbox.dart';
import '../feature/tasks/data/task_entity.dart';

@Entity()
class CategoryEntity {
  @Id()
  int id = 0;
  String name;

  @Backlink('category')
  final tasks = ToMany<TaskEntity>();

  CategoryEntity({required this.name});

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(name: json['name'] ?? json['title'] ?? 'Sans nom');
  }
}
