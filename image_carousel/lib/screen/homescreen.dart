import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      int currentpage = controller.page!.toInt();

      int nextpage = currentpage + 1;
      if (nextpage > 4) {
        nextpage = 0;
      }

      controller.animateToPage(
        nextpage,
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    // 메모리를 필요할 때 만 쓰기 위해 dispose하는게 좋음.
    controller.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 상태창의 색깔 바꾸는것..!
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
        body: PageView(
      controller: controller,
      children: [1, 2, 3, 4, 5]
          .map(
            (e) => (Image.asset("asset/img/image_$e.jpeg", fit: BoxFit.cover)),
          )
          .toList(),
    ));
  }
}
