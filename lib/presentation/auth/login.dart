import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/global_widget/button.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/presentation/auth/signup.dart';
import 'package:todolist_flutter/presentation/pages/onboarding.dart';
import '../../core/app_color.dart';
import '../../core/image_ressource.dart';
import '../../global_widget/title.dart';
import '../../global_widget/input_widget.dart';
import '../navigation_page.dart';
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
      final success = _authService.connecterUtilisateur(
        email: email,
        password: password,
      );
      if (success != null) {
        Get.to(() => NavigationPage());
      }
    }
  }

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
            Get.to(() => const Onboarding());
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(ImageRessource.auth, height: 150, width: 150),
                  const SizedBox(height: 15),
                  const Title(name: "BON RETOUR !!!"),
                  const SizedBox(height: 20),
                  const TextWidget(
                    name:
                        "Connectez-vous à l’application pour poursuivre le suivi de vos tâches",
                    color: AppColor.blanc,
                  ),
                  const SizedBox(height: 22),
                  Container(
                    child: Column(
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
                        const SizedBox(height: 100),
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
