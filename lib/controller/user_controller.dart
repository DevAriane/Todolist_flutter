import 'package:getxtra/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_flutter/models/user_model.dart';
import 'package:todolist_flutter/presentation/auth/login.dart';
import 'package:todolist_flutter/services/objectbox_service.dart';
import 'package:todolist_flutter/objectbox.g.dart';

class UserController extends GetxController {
  final Rxn<UserModel> unUtilisateur = Rxn<UserModel>();
  void onInit() {
    super.onInit();
    changerProfile();
  }

  void dispose() {}

  void deconnexion() {
    unUtilisateur.value = null;

    Get.to(() => const Login());
  }

  void changerProfile() {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      final profilTrouve = ObjectBoxService.userBox
          .query(UserModel_.uid.equals(firebaseUser.uid))
          .build()
          .findFirst();
      unUtilisateur.value = profilTrouve;
    }
  }
}
