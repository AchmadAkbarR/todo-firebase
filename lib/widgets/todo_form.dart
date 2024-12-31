import 'package:flutter/material.dart';
import 'package:todolist_app/helpers/database_helper.dart';
import 'package:todolist_app/models/todo.dart';

void showTodoForm(BuildContext context, Todo? todo, Function refreshList) {
  final TextEditingController namaCtrl = TextEditingController(text: todo?.nama ?? '');
  final TextEditingController deskripsiCtrl =
      TextEditingController(text: todo?.deskripsi ?? '');
  final DatabaseHelper dbHelper = DatabaseHelper();
  bool isNewTodo = todo == null;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        isNewTodo ? "Tambah Todo Baru" : "Edit Todo",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: InputDecoration(
                hintText: "Nama Todo",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.task),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deskripsiCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Deskripsi",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (namaCtrl.text.isEmpty || deskripsiCtrl.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Harap isi semua field'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            if (isNewTodo) {
              await dbHelper.addTodo(Todo(namaCtrl.text, deskripsiCtrl.text));
            } else {
              todo.nama = namaCtrl.text;
              todo.deskripsi = deskripsiCtrl.text;
              await dbHelper.updateTodo(todo);
            }

            Navigator.pop(context);
            refreshList();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(isNewTodo ? "Tambah" : "Simpan"),
        ),
      ],
    ),
  );
}
