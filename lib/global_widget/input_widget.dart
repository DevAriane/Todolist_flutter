import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist_flutter/core/app_color.dart';

class InputWidget extends StatelessWidget {
  final String name;
  final TextEditingController editing;
  final Icon? icon;
  final VoidCallback onTap;
  const InputWidget({
    super.key,
    required this.name,
    required this.editing,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editing,
      autocorrect: true,
      style: GoogleFonts.inter(color: AppColor.blanc, fontSize: 16),
      decoration: InputDecoration(
        hintText: name,
        hintStyle: const TextStyle(color: AppColor.placeholder),
        filled: true,
        fillColor: AppColor.inputFond,
        suffixIcon: icon != null
            ? IconButton(onPressed: onTap, icon: icon!)
            : null,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColor.buttonColor),
        ),

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColor.bordure),
        ),
      ),
    );
  }
}
