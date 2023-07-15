import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textstyle = TextStyle(fontSize: 16.0);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
          stream: streamNumbers(),
          builder: (context, AsyncSnapshot<int> snapshot) {

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Stream Builder',
                  style: textstyle.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 20.0),
                ),
                Text(
                  'Constate: ${snapshot.connectionState}',
                  style: textstyle,
                ),
                Text(
                  'Data: ${snapshot.data}',
                ),
                Text(
                  'Error: ${snapshot.error}',
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('setState'))
              ],
            );
          },
        ),
      ),
    );
  }


  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    // throw Exception('에러가 발생했습니다.');
    return random.nextInt(100);

  }

  Stream<int> streamNumbers() async* {
    for (int i=0; i<10; i++){

      if(i==5){
        throw Exception('i=5');
      }
    await Future.delayed(Duration(seconds: 1));
    yield i ;
    }
  }

}

