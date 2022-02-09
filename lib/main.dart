import 'package:flutter/material.dart';
import 'package:quote_app/Home_Screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///title of App
      title: 'Quote-App',

      ///DebugShowCheckedModeBanner
      debugShowCheckedModeBanner: false,

      ///Home
      home: HomePage(),
    );
  }
}
