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
      onTap: onTap,
      child: Container(
        width: 355,
        height: 70,
        decoration: BoxDecoration(
          color: AppColor.buttonColor.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.inter(
              color: AppColor.noir.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
