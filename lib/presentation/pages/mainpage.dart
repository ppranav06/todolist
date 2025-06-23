// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Text> tasks=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.only(left:20, top: 20),
      child: Column(children: const [
        Text("Hey, \${user}!.", style: TextStyle(fontSize: 35),)
      ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          tasks.add(Text("This is a task"));
          print(tasks);
          setState(() {}); 
        }
      ),
    );
  }
}

