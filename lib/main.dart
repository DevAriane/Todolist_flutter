import 'package:flutter/material.dart' hide SearchController;
import 'package:todolist_flutter/binding/initial_binding.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getxtra/get.dart' hide Get, GetMaterialApp;
import 'package:todolist_flutter/routes/app_pages.dart';
import './presentation/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './services/objectbox_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await ObjectBoxService.init();

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
      initialRoute: AppPages.intial,
      getPages: AppPages.routes,
      home: const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
