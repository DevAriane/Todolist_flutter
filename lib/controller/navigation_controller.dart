import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import '../presentation/pages/add_tasks_page.dart';
import '../presentation/pages/calendar_page.dart';
import '../presentation/pages/home_pages.dart';
import '../presentation/pages/profil_pages.dart';
import '../presentation/pages/home_view.dart';

class NavigationController extends GetxController {
  var tabIndex = 0.obs;

  final List<Widget> pages = [
    Center(child: HomeView()),
    Center(child: HomePages()),
    const Center(child: AddTasksPage()),
    const Center(child: ProfilPages()),
  ];

  void changeIndex(int index) {
    tabIndex.value = index;
  }
}
