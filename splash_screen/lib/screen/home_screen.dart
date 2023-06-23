import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Expanded / Flexible (column과 row 안에서만 사용해야함)
             // flex는 기본값이 1, 공간을 나눠먹는 비율(Expanded끼리)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Colors.red,
                  width: 50,
                  height: 50,
                ),
                Container(
                  color: Colors.orange,
                  width: 50,
                  height: 50,
                ),
                Container(
                  color: Colors.yellow,
                  width: 50,
                  height: 50,
                ),

                Container(
                  color: Colors.green,
                  width: 50,
                  height: 50,
                ),

              ],
            ),
              Container(
                color: Colors.orange,
                width: 50,
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.red,
                    width: 50,
                    height: 50,
                  ),
                  Container(
                    color: Colors.orange,
                    width: 50,
                    height: 50,
                  ),
                  Container(
                    color: Colors.yellow,
                    width: 50,
                    height: 50,
                  ),

                  Container(
                    color: Colors.green,
                    width: 50,
                    height: 50,
                  ),

                ],
              ),
              Container(
                color: Colors.green,
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      )
    );
  }
}