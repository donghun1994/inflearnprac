import 'package:datepicker/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'parisienne',
            fontSize: 80,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'sunflower',
            fontSize: 30,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Homescreen()));
}
