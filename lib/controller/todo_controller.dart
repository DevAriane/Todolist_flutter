import 'package:getxtra/get.dart';
import 'package:todolist_flutter/models/todo.dart';
import '../services/objectbox_service.dart';

class TodoController extends GetxController {
  final todos = <Todo>[].obs;
  var count = 0.obs;

  void addTodo(String title) {
    if (title.isEmpty) return;
    final todo = Todo(title: title, isDone: false, createdAt: DateTime.now());

    final id = ObjectBoxService.todoBox.put(todo);
    todo.id = id;

    todos.insert(0, todo);
    updateCompletedCount();
  }

  void toggleTodo(int id) {
    final toggledTodo = ObjectBoxService.todoBox.get(id);

    if (toggledTodo != null) {
      toggledTodo.isDone = !toggledTodo.isDone;
      ObjectBoxService.todoBox.put(toggledTodo);

      final index = todos.indexWhere((element) => element.id == id);
      if (index != -1) {
        todos[index] = toggledTodo;
      }

      updateCompletedCount();
    }
  }

  void deleteTodo(int id) {
    ObjectBoxService.todoBox.remove(id);
    todos.removeWhere((element) => element.id == id);
    updateCompletedCount();
  }

  void updateCompletedCount() {
    count.value = todos.where((todo) => todo.isDone).length;
  }

  int get completedCount => count.value;
}
