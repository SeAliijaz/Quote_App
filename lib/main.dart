import 'package:flutter/material.dart';
import 'package:quote_app/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///Title of app
      title: 'Quotes-App',

      ///DebugShowCheckedModeBanner
      debugShowCheckedModeBanner: false,

      ///home
      home: HomeScreen(),
    );
  }
}
