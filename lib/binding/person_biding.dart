import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import '../controller/person_controller.dart' show PersonController;

class PersonBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonController(), fenix: true);
  }
}
