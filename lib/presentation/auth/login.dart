import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/global_widget/button.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/models/user_model.dart';
import 'package:todolist_flutter/presentation/auth/signup.dart';
import 'package:todolist_flutter/presentation/pages/onboarding.dart';
import 'package:todolist_flutter/routes/app_routes.dart';
import '../../core/app_color.dart';
import '../../core/image_ressource.dart';
import '../../global_widget/title.dart';
import '../../global_widget/input_widget.dart';
import '../../services/authService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Authservice _authService = Authservice();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void handleSubmit(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      final result = await _authService.connecterUtilisateur(
        email: email,
        password: password,
      );

      if (result is UserModel) {
        Get.snackbar(
          "Connexion réussie",
          "Bon retour parmi nous !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.navigation);
      } else if (result is String) {
        Get.snackbar(
          "Erreur de connexion",
          result,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } else {
      Get.snackbar(
        "Champs vides",
        "Veuillez remplir tous les champs obligatoires.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: AppColor.buttonColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment
                              .topLeft, // Zone droite invisible (occupe 1/3 pour forcer le logo à rester au milieu)// Zone droite invisible (occupe 1/3 pour forcer le logo à rester au milieu)// Zone droite invisible (occupe 1/3 pour forcer le logo à rester au milieu)// Zone droite invisible (occupe 1/3 pour forcer le logo à rester au milieu),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const Onboarding());
                            },
                            child: Image.asset(ImageRessource.left, height: 24),
                          ),
                        ),
                      ),

                      Image.asset(ImageRessource.auth, height: 100, width: 100),

                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ),

                  const SizedBox(height: 15),
                  const Title(name: "BON RETOUR !!!"),
                  const SizedBox(height: 20),
                  const TextWidget(
                    name:
                        "Connectez-vous à l’application pour poursuivre le suivi de vos tâches",
                    color: AppColor.blanc,
                  ),
                  const SizedBox(height: 22),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 15),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.crop_square),
                              TextWidget(
                                name: "Se rappeller",
                                color: AppColor.blanc,
                              ),
                            ],
                          ),
                          TextWidget(
                            name: "Oublié",
                            color: AppColor.buttonColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Button(
                        name: "SE CONNECTER",
                        onTap: () {
                          final email = _email.text.trim();
                          final password = _password.text.trim();
                          handleSubmit(email, password);
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const TextWidget(
                            name: "Avez-vous déja un compte ? ",
                            color: AppColor.blanc,
                          ),
                          TextWidget(
                            name: "S’inscrire",
                            color: AppColor.buttonColor,
                            onTap: () {
                              Get.to(() => Signup());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
