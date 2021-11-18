import 'package:flutter/material.dart';
import 'package:todo_app/layout/home_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            showSelectedLabels: true),
        primarySwatch: Colors.pink,
      ),
      home: const HomeLayout(),
    );
  }
}
