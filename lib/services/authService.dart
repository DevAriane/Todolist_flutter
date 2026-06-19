import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/user_model.dart';
import '../main.dart';
import './objectbox_service.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> inscrireEtEnregistrerUtilisateur({
    required String nom,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential resultat = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = resultat.user;

      if (firebaseUser != null) {
        UserModel newUser = UserModel(
          name: nom,
          email: email,
          uid: firebaseUser.uid,
        );

        ObjectBoxService.userBox.put(newUser);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel?> connecterUtilisateur({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential resultat = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = resultat.user;

      if (firebaseUser != null) {
        final profilTrouve = ObjectBoxService.userBox
            .query(UserModel_.uid.equals(firebaseUser.uid))
            .build()
            .findFirst();
        return profilTrouve;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Aucun utilisateur trouvé pour cet e-mail.');
      } else if (e.code == 'wrong-password') {
        print('Mot de passe incorrect.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
