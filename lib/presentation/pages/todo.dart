import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_flutter/core/app_color.dart';
import 'package:todolist_flutter/global_widget/text_widget.dart';
import 'package:todolist_flutter/global_widget/textfield_widget.dart';
import 'package:todolist_flutter/routes/app_routes.dart';
import '../../controller/todo_controller.dart';

class Todo extends StatelessWidget {
  Todo({super.key});
  final TodoController _todocontroller = Get.find<TodoController>();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blanc,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To do list "),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: Obx(
              () => Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.task, size: 28, color: AppColor.noir),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: _todocontroller.todos.length > 0
                          ? Text(
                              _todocontroller.todos.length.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                color: AppColor.noir,
                name: "Voullez-vous ajouter une tache ??",
              ),
              const SizedBox(height: 10),
              TextfieldWidget(
                controller: _name,
                name: "Entrez un nom de votre tache ",
                line: 1,
                icon: Icons.add,
                ontap: () {
                  final title = _name.text.trim();
                  if (title.isNotEmpty) {
                    _todocontroller.addTodo(title);
                    _name.clear();
                  }
                },
              ),
              const SizedBox(height: 10),
              const TextWidget(
                color: AppColor.noir,
                name: "Liste de vos taches ",
              ),
              Expanded(
                child: Obx(() {
                  final todos = _todocontroller.todos;

                  if (todos.isEmpty) {
                    return const Center(
                      child: Text(
                        "vous n'avez pas de tache ",
                        style: TextStyle(color: AppColor.placeholder),
                      ),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];

                      return AnimatedTodoTile(
                        todo: todo,
                        onChanged: (bool? newValue) {
                          _todocontroller.toggleTodo(todo.id);
                        },
                        onTap: () {
                          Get.toNamed(AppRoutes.todoDetails);
                        },
                        onDelete: () {
                          _todocontroller.deleteTodo(todo.id);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedTodoTile extends StatefulWidget {
  final dynamic todo;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AnimatedTodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<AnimatedTodoTile> createState() => _AnimatedTodoTileState();
}

class _AnimatedTodoTileState extends State<AnimatedTodoTile> {
  late double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = widget.todo.isDone ? 0.4 : 1.0;
  }

  @override
  void didUpdateWidget(covariant AnimatedTodoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todo.isDone) {
      if (_opacity == 1.0) {
        setState(() {
          _opacity = 0.4;
        });
      }
    } else {
      setState(() {
        _opacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.todo.isDone ? _opacity : 1.0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      onEnd: () {
        if (widget.todo.isDone) {
          setState(() {
            _opacity = _opacity == 1.0 ? 0.4 : 1.0;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.placeholder, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Checkbox(
                value: widget.todo.isDone,
                activeColor: AppColor.buttonColor,
                onChanged: widget.onChanged,
              ),
              Expanded(
                child: InkWell(
                  onTap: widget.onTap,
                  child: Text(widget.todo.title),
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: AppColor.noir, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
