import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  @Id()
  int id = 0;
  final String title;
  bool isDone;
  DateTime createdAt;
  Todo({required this.title, required this.isDone, required this.createdAt});
}
