import 'package:flutter/material.dart';
import 'package:nagation/screen/home_screen.dart';
import 'package:nagation/screen/route_one_screen.dart';
import 'package:nagation/screen/route_three_screen.dart';
import 'package:nagation/screen/route_two_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    // home: HomeScreen(),
    routes: {
      '/' :(context) => HomeScreen(),
      '/one' : (context) => RouteOneScreen(),
      '/two' : (context) => RouteTwoScreen(),
      '/three' : (context) => RouteThreeScreen(),
    },
  ));
}
