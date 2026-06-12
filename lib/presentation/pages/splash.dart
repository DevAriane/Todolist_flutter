import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getxtra/get.dart';
import './onboarding.dart';
import '../../core/image_ressource.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2000), () {
      Get.to(() => const Onboarding());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backg,
      appBar: AppBar(backgroundColor: AppColor.backg),
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutBack,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageRessource.logo, height: 100, width: 100),
              const SizedBox(height: 15),
              Text(
                "TO DO LIST",
                style: GoogleFonts.hennyPenny(
                  color: AppColor.blanc,
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
