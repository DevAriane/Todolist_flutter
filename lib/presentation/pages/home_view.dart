import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/global_widget/app_drawer.dart';
import 'package:todolist_flutter/global_widget/categories_habit.dart';
import 'package:todolist_flutter/global_widget/create_habit.dart';
import 'package:todolist_flutter/global_widget/habits.dart';
import 'package:todolist_flutter/global_widget/search_bar_habit.dart';
import '../../feature/habit/controllers/habit_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final HabitController controller = Get.find<HabitController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.backg,
      drawer: const AppDrawer(),
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
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
                const Text(
                  "Bonjour, Hattie !",
                  style: TextStyle(color: AppColor.blanc, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final taskCount = controller.habits.length;
                  return Text.rich(
                    TextSpan(
                      text: "Vous avez ",
                      style: const TextStyle(
                        color: AppColor.blanc,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: taskCount == 0
                              ? "aucun projet"
                              : taskCount == 1
                              ? "1 projet"
                              : "$taskCount projets en cours",
                          style: const TextStyle(
                            color: AppColor.buttonColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " aujourd'hui."),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                SearchbarsHabit(),
                const SizedBox(height: 10),
                CategoriesHabit(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Défis récurrents",
                      style: TextStyle(color: AppColor.blanc),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return const CreateHabit();
                          },
                        );
                      },
                      icon: const Icon(Icons.add_circle, color: AppColor.blanc),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Habits(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
