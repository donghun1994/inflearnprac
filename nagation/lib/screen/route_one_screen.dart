import 'package:flutter/material.dart';
import 'package:nagation/layout/main_layout.dart';
import 'package:nagation/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {
  final int? number;

  const RouteOneScreen({
    this.number,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Route One',
      children: [
        Text(
          'argument : ${number.toString()}',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(456);
          },
          child: Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => RouteTwoScreen(),
              settings: RouteSettings(
                arguments: 789,
              ),
            ));
          },
          child: Text('Push'),
        ),
      ],
    );
  }
}
