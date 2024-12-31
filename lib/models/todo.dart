class Todo {
  String? id; // ID dokumen di Firestore
  String nama;
  String deskripsi;
  bool done;

  Todo(this.nama, this.deskripsi, {this.done = false, this.id});

  /// Konversi dari Map ke Todo
  factory Todo.fromFirestore(Map<String, dynamic> map, String id) {
    return Todo(
      map['nama'] as String,
      map['deskripsi'] as String,
      done: (map['done'] as bool?) ?? false, // Set default false jika null
      id: id,
    );
  }

  /// Konversi dari Todo ke Map
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'done': done,
    };
  }
}
