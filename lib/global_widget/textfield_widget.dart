import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/app_color.dart';

class TextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final int? line;
  final VoidCallback? ontap;
  final IconData? icon;
  const TextfieldWidget({
    super.key,
    required this.controller,
    required this.name,
    this.line,
    this.ontap,
    this.icon,
  });

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.line,
      style: const TextStyle(color: AppColor.blanc),
      decoration: InputDecoration(
        hintText: widget.name,
        hintStyle: const TextStyle(color: AppColor.placeholder),
        filled: true,

        fillColor: Colors.grey[900],
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: AppColor.buttonColor),
        ),
        suffixIcon: widget.icon != null
            ? IconButton(
                onPressed: widget.ontap,
                icon: Icon(widget.icon, color: AppColor.blanc, size: 24),
              )
            : null,

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: AppColor.bordure),
        ),
      ),
    );
  }
}
