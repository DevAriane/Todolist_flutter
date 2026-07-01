import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist_flutter/routes/app_routes.dart';
import '../../core/image_ressource.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2500), () {
      Get.toNamed(AppRoutes.onboarding);
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
      appBar: AppBar(backgroundColor: AppColor.backg, elevation: 0),
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _controller,
            child: ScaleTransition(
              scale: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageRessource.logo, height: 200),
                  const SizedBox(height: 20),
                  Text(
                    "TO DO LIST",
                    style: GoogleFonts.hennyPenny(
                      color: AppColor.blanc.withValues(alpha: 0.9),
                      fontSize: 36,
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
