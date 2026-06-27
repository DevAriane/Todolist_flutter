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

  final RxBool _isLoading = false.obs;

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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
                  Image.asset(ImageRessource.auth, height: 50, width: 50),
                  const SizedBox(height: 15),
                  const Title(name: "CREER UN COMPTE ?"),
                  const SizedBox(height: 22),
                  Column(
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

                      Obx(() {
                        if (_isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.buttonColor,
                              ),
                            ),
                          );
                        }

                        return Button(
                          name: "S'inscrire",
                          onTap: () async {
                            final nom = _name.text.trim();
                            final email = _email.text.trim();
                            final password = _password.text.trim();

                            if (nom.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty) {
                              Get.snackbar(
                                "Champs obligatoires",
                                "Veuillez remplir tous les champs marqués d'un astérisque (*).",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            try {
                              _isLoading.value = true;

                              final String? erreur = await _authService
                                  .inscrireEtEnregistrerUtilisateur(
                                    nom: nom,
                                    email: email,
                                    password: password,
                                  );

                              if (erreur == null) {
                                Get.snackbar(
                                  "Inscription réussie",
                                  "Votre compte a été créé avec succès !",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );

                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                Get.offAllNamed(AppRoutes.navigation);
                              } else {
                                Get.snackbar(
                                  "Erreur d'inscription",
                                  erreur,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 4),
                                );
                              }
                            } finally {
                              _isLoading.value = false;
                            }
                          },
                        );
                      }),

                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const TextWidget(
                              name: "Avez-vous déjà un compte ? ",
                              color: AppColor.blanc,
                            ),
                            InkWell(
                              onTap: () => Get.to(() => const Login()),
                              child: const TextWidget(
                                name: "Se connecter ",
                                color: AppColor.buttonColor,
                              ),
                            ),
                          ],
                        ),
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
