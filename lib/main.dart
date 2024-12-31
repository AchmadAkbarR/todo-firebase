import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist_app/firebase_options.dart';
import 'package:todolist_app/screens/todo_page.dart';
import 'package:todolist_app/screens/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Penting untuk Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/', // Set landing page sebagai halaman awal
      routes: {
        '/': (context) => const LandingPage(), // Route ke LandingPage
        '/todoPage': (context) => const TodoPage(), // Route ke TodoPage
      },
    );
  }
}
