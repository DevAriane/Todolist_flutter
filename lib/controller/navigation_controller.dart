import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/pages/add_tasks_page.dart';
import '../presentation/pages/home_pages.dart';
import '../presentation/pages/profil_pages.dart';
import '../presentation/pages/home_view.dart';
import '../presentation/pages/todo.dart';

class NavigationController extends GetxController {
  var tabIndex = 0.obs;

  final List<Widget> pages = [
    Center(child: Todo()),
    Center(child: HomeView()),
    Center(child: HomePages()),
    const Center(child: AddTasksPage()),
    Center(child: ProfilPages()),
  ];

  void changeIndex(int index) {
    tabIndex.value = index;
  }
}
