import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TestWidget(
              label: 'test1',
            ),
            TestWidget(label: 'test2'),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('빌드!'),
            )
          ],
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  final String label;
  const TestWidget({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('$label build 실행!');
    return Container(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
