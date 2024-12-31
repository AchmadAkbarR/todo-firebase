import 'package:flutter/material.dart';
import 'package:todolist_app/helpers/database_helper.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/widgets/todo_form.dart';
import 'package:todolist_app/widgets/todo_list_item.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> handleDelete(Todo todo) async {
    if (todo.id != null) {
      await dbHelper.deleteTodo(todo.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Todo dihapus'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await dbHelper.addTodo(Todo(
                todo.nama,
                todo.deskripsi,
                done: todo.done,
              ));
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus todo: ID tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTodoForm(context, null, () {}),
        icon: const Icon(Icons.add),
        label: const Text("Tambah Todo"),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildTodoList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) {
          // Implement search here if needed
        },
        decoration: InputDecoration(
          hintText: 'Cari todo...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    return StreamBuilder<List<Todo>>(
      stream: dbHelper.getAllTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final todos = snapshot.data ?? [];

        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada todo',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return TodoListItem(
              todo: todos[index],
              onDelete: handleDelete,
              onToggle: (todo) async {
                todo.done = !todo.done;
                await dbHelper.updateTodo(todo);
              },
              onEdit: (todo) => showTodoForm(context, todo, () {}),
            );
          },
        );
      },
    );
  }
}
