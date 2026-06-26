import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/routes/app_routes.dart';
import '../../global_widget/button.dart';
import '../../core/image_ressource.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../navigation_page.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  void verifierSessionEtNaviguer() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Get.offAllNamed(AppRoutes.navigation);
    } else {
      Get.to(() => const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backg,
      appBar: AppBar(backgroundColor: AppColor.backg, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(ImageRessource.onboarding, height: 320),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Gérez et suivez vos tâches quotidiennes en toute simplicité grâce à cette mini-application",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppColor.blanc, fontSize: 16),
              ),

              const Spacer(),
              Button(name: "COMMENCER", onTap: verifierSessionEtNaviguer),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
