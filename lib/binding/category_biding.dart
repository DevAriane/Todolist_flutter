import 'package:get/get.dart';
import 'package:getxtra/get.dart' hide Get;
import '../controller/category_controller.dart';

class CategoryBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(), fenix: true);
  }
}
