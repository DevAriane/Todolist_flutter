import 'package:flutter/material.dart' hide SearchController;
import 'package:todolist_flutter/binding/initial_binding.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getxtra/get.dart' hide Get, GetMaterialApp;
import './presentation/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controller/task_controller.dart';
import 'controller/category_controller.dart';
import 'controller/date_picker_controller.dart';
import 'controller/search_controller.dart';
import 'controller/person_controller.dart';
import './services/objectbox_service.dart';
import 'controller/habit_controller.dart';
import 'controller/category_habit_controller.dart';
import './controller/todo_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await ObjectBoxService.init();

  Get.lazyPut(() => CategoryController(), fenix: true);
  Get.lazyPut(() => CategoryHabitController(), fenix: true);
  Get.lazyPut(() => HabitController(), fenix: true);
  Get.lazyPut(() => TaskController(), fenix: true);
  Get.lazyPut(() => DatePickerController(), fenix: true);
  Get.lazyPut(() => PersonController(), fenix: true);
  Get.lazyPut(() => SearchController(), fenix: true);
  Get.lazyPut(() => TodoController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TodoList',

      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.backg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.blanc),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialBinding: InitialBinding(),
      home: const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
