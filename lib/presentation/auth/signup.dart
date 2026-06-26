import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/global_widget/button.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/presentation/auth/login.dart';
import 'package:todolist_flutter/routes/app_routes.dart';
import '../../core/app_color.dart';
import '../../core/image_ressource.dart';
import '../../global_widget/title.dart';
import '../../global_widget/input_widget.dart';
import '../../services/authService.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final Authservice _authService = Authservice();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(() => const Login());
          },
          child: Image.asset(ImageRessource.left, height: 24),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: [AppColor.buttonColor, AppColor.backg],
              stops: [0.1, 0.13],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImageRessource.auth, height: 50, width: 50),
                const SizedBox(height: 15),
                const Title(name: "CREER UN COMPTE ?"),
                const SizedBox(height: 20),
                const TextWidget(
                  name:
                      "Rejoignez-nous dès aujourd'hui et gardez le contrôle de toutes vos tâches en un seul endroit",
                  color: AppColor.blanc,
                ),
                const SizedBox(height: 22),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(name: "Nom*:", color: AppColor.blanc),
                      const SizedBox(height: 15),
                      InputWidget(
                        name: "Ariane la STAR",
                        editing: _name,
                        onTap: () {},
                      ),
                      const SizedBox(height: 15),
                      const TextWidget(
                        name: "Adresse email*:",
                        color: AppColor.blanc,
                      ),
                      const SizedBox(height: 15),
                      InputWidget(
                        name: "example@gmail.com",
                        editing: _email,
                        onTap: () {},
                      ),
                      const SizedBox(height: 15),
                      const TextWidget(
                        name: "Mot de passe*:",
                        color: AppColor.blanc,
                      ),
                      const SizedBox(height: 15),
                      InputWidget(
                        name: "arianeAJ20060318",
                        editing: _password,
                        onTap: () {},
                        icon: const Icon(Icons.visibility_off),
                      ),

                      const SizedBox(height: 30),
                      Button(
                        name: "S'incrire",
                        onTap: () async {
                          final nom = _name.text.trim();
                          final email = _email.text.trim();
                          final password = _password.text.trim();

                          final String? erreur = await _authService
                              .inscrireEtEnregistrerUtilisateur(
                                nom: nom,
                                email: email,
                                password: password,
                              );

                          if (erreur == null) {
                            Get.offAllNamed(AppRoutes.navigation);
                          } else {
                            Get.snackbar(
                              "Erreur d'inscription",
                              erreur,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 100),
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            TextWidget(
                              name: "Avez-vous déja un compte ? ",
                              color: AppColor.blanc,
                            ),
                            TextWidget(
                              name: "Se connecter ",
                              color: AppColor.buttonColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
