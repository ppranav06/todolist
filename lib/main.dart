import 'package:flutter/material.dart';
import 'presentation/pages/splashpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
    );
  }
}
