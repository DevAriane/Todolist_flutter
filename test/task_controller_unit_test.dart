import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todolist_flutter/controller/category_controller.dart';
import 'package:todolist_flutter/controller/person_controller.dart';
import 'package:todolist_flutter/controller/task_controller.dart';
import 'package:todolist_flutter/models/task_entity.dart';
import 'package:todolist_flutter/models/category_entity.dart';
import 'package:todolist_flutter/models/person_entity.dart';
import 'package:todolist_flutter/services/objectbox_service.dart';
import 'category_controller_unit_test.mocks.dart';

@GenerateMocks([
  MockSpec<CategoryController>(),
  MockSpec<PPersonController>(),
  MockSpec<Box<TaskEntity>>(as: #MockTaskBox),
  MockSpec<Box<CategoryEntity>> (as: #MockCategoryBox ),
  MockSpec<Box<PersonEntity>> (as: #MockPersonBox),
])