import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/app_color.dart';

class TextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final int? line;
  const TextfieldWidget({
    super.key,
    required this.controller,
    required this.name,
    this.line,
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
          borderSide: BorderSide(color: Colors.white60),
        ),

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: AppColor.bordure),
        ),
      ),
    );
  }
}
