import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist_flutter/core/app_color.dart';

class TextWidget extends StatelessWidget {
  final String name;
  final Color color;
  const TextWidget({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: GoogleFonts.inter(color: color, fontSize: 16),
    );
  }
}
