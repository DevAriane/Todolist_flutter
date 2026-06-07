import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    const url = 'https://api.jsonbin.io/v3/b/6a228e79da38895dfe8b3a4f/latest';
    final response = await _dio.get(url);
    final tasksJson = response.data['record']['tasks'] as List;
    return tasksJson.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    const url = 'https://api.jsonbin.io/v3/b/6a228e79da38895dfe8b3a4f/latest';
    final response = await _dio.get(url);
    final categoriesJson = response.data['record']['categories'] as List;
    return categoriesJson.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchPersons() async {
    const url = 'https://api.jsonbin.io/v3/b/6a228e79da38895dfe8b3a4f/latest';
    final response = await _dio.get(url);
    final personsJson = response.data['record']['persons'] as List;
    return personsJson.cast<Map<String, dynamic>>();
  }
}
