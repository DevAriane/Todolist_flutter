import 'package:flutter/material.dart' hide SearchController;
import 'package:todolist_flutter/binding/initial_binding.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist_flutter/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './services/objectbox_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Erreur d'initialisation Firebase : $e");
  }

  String? erreurObjectBox;

  try {
    await ObjectBoxService.init();
  } catch (e) {
    erreurObjectBox = e.toString();
  }

  if (erreurObjectBox != null) {
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[900],
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "🚨 ERREUR NATIVE OBJECTBOX :\n\n$erreurObjectBox",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.backg.withValues(alpha: 0.9),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.blanc),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppPages.intial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
