import 'package:flutter/material.dart';
import 'UI/home_screen.dart';
import 'UI/new_note_screen.dart';
import 'UI/splash_screen.dart';
import 'UI/edit_note_screen.dart';

void main() async {
  runApp(MyApp());
}

// ignore:
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const splashScreen(),
      routes: {
        "home": (context) => HomeScreen(),
        "AddNote": (context) => NewNoteScreen(),
        "EditNote": (context) => EditNoteScreen(),
      },
    );
  }
}
