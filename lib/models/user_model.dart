import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  @Id()
  int id = 0;

  String name;
  String email;
  String uid;

  UserModel({required this.name, required this.email, required this.uid});
}
