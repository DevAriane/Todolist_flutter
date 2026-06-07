import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';

import '../models/task_entity.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';
import '../models/person_entity.dart';

class PersonController extends GetxController {
  final persons = <PersonController>[].obs;
  final isLoading = false.obs;
}
