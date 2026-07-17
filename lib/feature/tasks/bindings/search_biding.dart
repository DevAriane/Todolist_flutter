import 'package:get/get.dart';
import 'package:todolist_flutter/feature/tasks/controllers/search_controller.dart';

class SearchBiding extends Bindings {
  @override
  void dependencies(){
     Get.lazyPut(() => SearchController(), fenix: true);
  }
}