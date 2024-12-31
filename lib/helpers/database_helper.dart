import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('todos');

  /// Ambil semua todo secara real-time
  Stream<List<Todo>> getAllTodos() {
    return todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Cari todo berdasarkan teks
  Future<List<Todo>> searchTodo(String teks) async {
    try {
      final snapshot = await todosCollection
          .where('nama', isGreaterThanOrEqualTo: teks)
          .where('nama', isLessThanOrEqualTo: '$teks\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        return Todo.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error searching todos: $e");
      return [];
    }
  }

  /// Tambahkan todo baru
  Future<void> addTodo(Todo todo) async {
    try {
      await todosCollection.add(todo.toMap());
      print("Todo added successfully: ${todo.toMap()}");
    } catch (e) {
      print("Failed to add todo: $e");
    }
  }

  /// Perbarui todo
  Future<void> updateTodo(Todo todo) async {
    if (todo.id == null) {
      throw Exception("Todo ID cannot be null for update");
    }
    try {
      await todosCollection.doc(todo.id).update(todo.toMap());
      print("Todo updated successfully: ${todo.toMap()}");
    } catch (e) {
      print("Failed to update todo: $e");
    }
  }

  /// Hapus todo berdasarkan ID
  Future<void> deleteTodo(String id) async {
    try {
      await todosCollection.doc(id).delete();
      print("Todo deleted successfully with ID: $id");
    } catch (e) {
      print("Failed to delete todo: $e");
    }
  }
}
