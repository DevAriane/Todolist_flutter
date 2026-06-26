import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onTap;
  const TextWidget({
    super.key,
    required this.name,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(name, style: GoogleFonts.inter(color: color, fontSize: 16)),
    );
  }
}
