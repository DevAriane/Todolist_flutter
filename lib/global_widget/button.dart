import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_color.dart';

class Button extends StatelessWidget {
  final String name;
 final VoidCallback onTap;
  const Button({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        width: 355,
        height: 70,
        decoration: const BoxDecoration(
          color: AppColor.buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.inter(
              color: AppColor.noir,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
