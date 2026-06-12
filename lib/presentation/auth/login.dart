import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../core/image_ressource.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        leading: const Icon(
          Icons.arrow_circle_left,
          color: AppColor.blanc,
          size: 24,
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.buttonColor, AppColor.backg],
              stops: [0.1, 0.13],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Image.asset(ImageRessource.auth, height: 150,width: 150,)
            ],
          ),
        ),
      ),
    );
  }
}
