import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/models/todo.dart';
import 'package:intl/intl.dart';

class Detailtodo extends StatelessWidget {
  final Todo todo;
  const Detailtodo({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blanc,
      appBar: AppBar(centerTitle: true, title: const Text("Détail Todo")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style: GoogleFonts.inter(
                  color: AppColor.noir,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextWidget(
                name:
                    "créé le ${DateFormat('dd/MM/yyyy').format(todo.createdAt)}",
                color: AppColor.noir,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
