import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/presentation/pages/home_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getxtra/get.dart';

import 'controller/task_controller.dart';
import 'controller/category_controller.dart';
import './controller/color_controller.dart';
import 'controller/date_picker_controller.dart';
import './services/objectbox_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxService.init();

  Get.lazyPut(() => CategoryController());
  Get.lazyPut(() => ColorController());
  Get.lazyPut(() => TaskController());
  Get.lazyPut(() => DatePickerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.noir,
        colorScheme: .fromSeed(seedColor: AppColor.blanc),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: HomePages(),
      debugShowCheckedModeBanner: false,
    );
  }
}
