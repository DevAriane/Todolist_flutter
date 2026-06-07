import 'package:objectbox/objectbox.dart';
import './category_entity.dart';

@Entity()
class TaskEntity {
  @Id()
  int id = 0;
  String title;
  String? description;
  bool completed;

  final category = ToOne<CategoryEntity>();

  TaskEntity({required this.title, this.completed = false, this.description});
}
