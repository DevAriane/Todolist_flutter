import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import '../controller/navigation_controller.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  final controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.noir,
      body: Obx(() => controller.pages[controller.tabIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.noir,
          selectedItemColor: AppColor.or,
          unselectedItemColor: AppColor.blanc,
          iconSize: 20,
          selectedFontSize: 16,
          unselectedFontSize: 12,
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tache'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ajouter'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
