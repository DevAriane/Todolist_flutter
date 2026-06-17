import 'package:flutter/material.dart';

import 'package:getxtra/get.dart';

import 'create_person.dart';
import './create_category.dart';
import './create_category_habit.dart';
import './create_habit.dart';
import './categories.dart';
import './categories_habit.dart';
import './habits.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.7,
      child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListTile(
              leading: const Icon(Icons.repeat),
              title: const Text('Habitudes'),
              onTap: () => Get.off(() => Habits()),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Catégories'),
              onTap: () => Get.off(() => Categories()),
            ),
            ListTile(
              leading: const Icon(Icons.star_half),
              title: const Text('Cat. Habitudes'),
              onTap: () => Get.off(() => CategoriesHabit()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Créer Personne'),
              onTap: () => Get.off(() => const CreatePerson()),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Nouvelle Cat.'),
              onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const CreateCategory(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Nouvelle Cat. Hab.'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: true,
                  showDragHandle: true,
                  backgroundColor: Colors.transparent,
                  useSafeArea: true,
                  builder: (context) {
                    return const CreateCategoryHabit();
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.more_time),
              title: const Text('Nouv. Habitude'),
              onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const CreateHabit(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
