import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/global_widget/categories.dart';
import 'package:todolist_flutter/global_widget/categories_habit.dart';
import 'package:todolist_flutter/global_widget/horizontal_date_picker.dart';
import 'package:todolist_flutter/global_widget/search_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backg,
      appBar: AppBar(
        backgroundColor: AppColor.backg,
        actionsPadding: const EdgeInsets.all(20),
        centerTitle: true,
        title: const Text(
          "Zen List",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColor.blanc,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: const [Icon(Icons.notifications_none, color: AppColor.blanc)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Searchbars(),
                const SizedBox(height: 10),
                CategoriesHabit(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
