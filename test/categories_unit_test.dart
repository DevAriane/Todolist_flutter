
import 'package:objectbox/objectbox.dart'; 
import 'package:todolist_flutter/controller/category_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'package:todolist_flutter/services/api_service.dart';
import 'category_controller_unit_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  ApiService,
  TaskController, 
], customMocks: [
  MockSpec<Box<CategoryEntity>>(as: #MockCategoryBox),
])
void main() {
  
}
