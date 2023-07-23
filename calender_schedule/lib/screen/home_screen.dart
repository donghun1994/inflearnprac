import 'package:calender_schedule/component/schedule_bottmsheet.dart';
import 'package:calender_schedule/component/schedule_card.dart';
import 'package:calender_schedule/const/const.dart';
import 'package:calender_schedule/const/today_banner.dart';
import 'package:calender_schedule/model/schedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../component/calender.dart';
import '../database/drift_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // UTC 기준으로 데이트를 넣고 있음
  // 처음 재시작을 했을 때와 DB에 시간을 처음 넣을 때 현재 시간만을 기준으로 넣고 있음
  // 처음부터 selectedDay를 생성해주는 것이 중요함
  DateTime selectedDay = DateTime.utc(
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
                selectedDay: selectedDay,
              ),
              SizedBox(
                height: 8,
              ),
              _ScheduleList(selectedDate: selectedDay),
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
            return ScheduleBottomSheet(selectedDate: selectedDay,);
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
  final DateTime selectedDate;

  const _ScheduleList({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchScedules(selectedDate),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }

              if(snapshot.hasData && snapshot.data!.isEmpty){
                return Center(
                  child: Text('스케줄이 없습니다.'),
                );
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 8,
                  );
                },
                //Listview builder는 item 의 수만큼 가져와서 그리는데
                //스크롤하면서 내려가는 순간에 그림을 그린다(한번에 데이터를 다 가져와서 저장했다가 그리는게 아님(메모리 사용에 효과적)
                itemBuilder: (context, index) {

                  final scheduleWithColor = snapshot.data![index];

                  return Dismissible(
                    // unique 한 값을 key를 사용해야하는데 그걸 scheduleid로 사용!
                    key : ObjectKey(scheduleWithColor.schedule.id),
                    direction: DismissDirection.endToStart,
                    // 데이터베이스에서 지우는 것들을 추가하지 않으면 안지워짐(화면만 지워지기 때문에..!)
                    // dismiss event가 생겼을 때 처리!
                    onDismissed: (DismissDirection direction) {
                      GetIt.I<LocalDatabase>().removeSchedule(scheduleWithColor.schedule.id);
                    },
                    child: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return ScheduleBottomSheet(selectedDate: selectedDate,scheduleId: scheduleWithColor.schedule.id,);
                          },
                        );
                      },
                      child: ScheduleCard(
                        startTime:scheduleWithColor.schedule.startTime ,
                        endTime: scheduleWithColor.schedule.endTime,
                        content: scheduleWithColor.schedule.content,
                        color: Color(int.parse('FF${scheduleWithColor.categoryColor.hexcode}', radix: 16)),
                      ),
                    ),
                  );
                },
              );
            }
          )),
    );
  }
}
