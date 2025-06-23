// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'mainpage.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 5), (){
      Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MainPage()));
       // Navigator is a stack: 
    }); 
    // Future - used for delays and stuff; delayed(for 2 seconds, after which an anonymous function (){} is run)
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("To-do list",
            style: TextStyle(fontSize: 30, color: Colors.amber),
            ),
            Image.asset("assets/splash.png"),
            CircularProgressIndicator(),
            // add a personalised message (after implementing login or login-like)
          ],
        ),
      )
    );
  }
}