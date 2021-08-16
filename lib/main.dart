import 'package:flutter/material.dart';
import 'package:flutter_movies/src/screens/todos/todo_tab_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple TODO',
      theme: ThemeData(
        accentColor: Colors.redAccent,
        primaryColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: TodoTabController(),
    );
  }
}
