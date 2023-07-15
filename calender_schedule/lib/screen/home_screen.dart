import 'package:calender_schedule/component/new_schedule_bottmsheet.dart';
import 'package:calender_schedule/component/schedule_card.dart';
import 'package:calender_schedule/const/const.dart';
import 'package:calender_schedule/const/today_banner.dart';
import 'package:flutter/material.dart';

import '../component/calender.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: SafeArea(
          child: Column(
            children: [
              Calender(
                onDaySelected: onDaySeleted,
                selectedDay: selectedDay,
                focusedDay: focusedDay,
              ),
              SizedBox(
                height: 8,
              ),
              TodayBanner(
                selectedDay: DateTime.now(),
                scheduledCount: 3,
              ),
              SizedBox(
                height: 8,
              ),
              _ScheduleList(),
            ],
          ),
        ));
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return ScheduleBottomSheet();
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: PRIMARY_COLOR,
    );
  }

  onDaySeleted(selectedDay, focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 8,
              );
            },
            //Listview builder는 item 의 수만큼 가져와서 그리는데
            //스크롤하면서 내려가는 순간에 그림을 그린다(한번에 데이터를 다 가져와서 저장했다가 그리는게 아님(메모리 사용에 효과적)
            itemCount: 5,
            itemBuilder: (context, index) {
              return ScheduleCard(
                startTime: 12,
                endTime: 14,
                content: '프로그래밍 공부하기. $index',
                color: Colors.red,
              );
            },
          )),
    );
  }
}
