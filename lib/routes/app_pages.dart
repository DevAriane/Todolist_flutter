import 'package:todolist_flutter/binding/home_pages_biding.dart';
import 'package:todolist_flutter/binding/navigation_biding.dart';
import 'package:todolist_flutter/binding/todo_details_biding.dart';
import 'package:todolist_flutter/binding/update_task_binding.dart';
import 'package:todolist_flutter/global_widget/update_task.dart';
import 'package:todolist_flutter/models/todo.dart';
import 'package:todolist_flutter/presentation/navigation_page.dart';
import 'package:todolist_flutter/presentation/pages/detailTodo.dart';
import 'package:todolist_flutter/presentation/pages/home_pages.dart';
import 'package:todolist_flutter/presentation/pages/onboarding.dart';
import 'package:todolist_flutter/presentation/pages/splash.dart';
import 'package:todolist_flutter/routes/app_routes.dart';
import 'package:get/get.dart';
import '../binding/home_view_biding.dart';
import '../presentation/pages/home_view.dart';
import '../models/task_entity.dart';

abstract class AppPages {
  static const intial = AppRoutes.splash;

  static final routes = [
    GetPage(name: intial, page: () => const Splash()),

    GetPage(name: AppRoutes.onboarding, page: ()=>const Onboarding()),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeViewBiding(),
    ),

    GetPage(
      name: AppRoutes.homePages,
      page: () => HomePages(),
      binding: HomePagesBiding(),
    ),

    GetPage(
      name: AppRoutes.todoDetails,
      page: () => Detailtodo(todo: Get.arguments as Todo),
      binding: TodoDetailsBiding(),
    ),

    GetPage(
      name: AppRoutes.updateTask,
      page: () {
        final task = Get.arguments as TaskEntity;
        return UpdateTask(idTask: task.id);
      },
      binding: UpdateTaskBinding(),
    ),

    GetPage(
      name: AppRoutes.navigation,
      page: () => NavigationPage(),
      binding: NavigationBiding(),
    ),
  ];
}
