import 'package:get/get.dart';
import '../controllers/category_controller.dart';

class CategoryBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(), fenix: true);
  }
}
