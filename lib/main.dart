import 'package:flutter/material.dart';
import 'chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Sfondo bianco
        appBarTheme: const AppBarTheme(
          color: Colors.blue, // Colore della barra superiore
          foregroundColor:
              Colors.white, // Colore del testo e delle icone nella barra
        ),
      ),
      home: ChatPage(),
    );
  }
}
