import 'package:objectbox/objectbox.dart';
import './task_entity.dart';

@Entity()
class CategoryEntity {
  @Id()
  int id = 0;
  String name;

  @Backlink('category')
  final tasks = ToMany<TaskEntity>();

  CategoryEntity({required this.name});
}
