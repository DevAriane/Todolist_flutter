import 'package:getxtra/get.dart';
import 'package:get/get.dart' hide Get;
import '../controller/user_controller.dart';
import '../controller/color_controller.dart';
import '../controller/navigation_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => ColorController(), fenix: true);
  }
}
