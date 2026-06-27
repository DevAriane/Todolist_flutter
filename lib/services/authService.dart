import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_flutter/objectbox.g.dart';
import '../models/user_model.dart';
import './objectbox_service.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> inscrireEtEnregistrerUtilisateur({
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
        return null;
      }
      return "Une erreur inconnue est survenue.";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "Cette adresse email est déjà associée à un compte.";
        case 'weak-password':
          return "Le mot de passe est trop faible.";
        case 'invalid-email':
          return "Le format de l'adresse email est incorrect.";
        default:
          return e.message ?? "Une erreur est survenue lors de l'inscription.";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> connecterUtilisateur({
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

        return profilTrouve ??
            UserModel(name: "Utilisateur", email: email, uid: firebaseUser.uid);
      }
      return "Impossible de récupérer le profil.";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        return "Aucun compte ne correspond à cet email ou mot de passe incorrect.";
      } else if (e.code == 'wrong-password') {
        return "Mot de passe incorrect.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
