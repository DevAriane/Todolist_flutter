import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist_flutter/core/app_color.dart';

class Title extends StatelessWidget {
  final String name;
  const Title({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(name, style: GoogleFonts.inter(color: AppColor.blanc, fontSize: 24 , fontWeight: FontWeight.bold));
  }
}
