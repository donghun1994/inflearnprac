import 'package:calender_schedule/const/const.dart';
import 'package:calender_schedule/database/drift_database.dart';
import 'package:calender_schedule/model/category_color.dart';
import 'package:drift/drift.dart'
    show Value; // drift 패키지에 column이라는 클래스가 있어서 에러가 나기때문에 value만 가져오도록 수정..
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet(
      {Key? key, required this.selectedDate, this.scheduleId})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formkey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        // 키보드 올라왔을 때 입력안하고도 키보드 안보이게 내리는 UX
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('스케줄을 불러올 수 없습니다.'),
              );
            }

            //futurebuilder가 처음 실행됐고 로딩중일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // Futere가 실행이 되고
            // 값이 있는데 단 한 번도 startTime이 세팅되지 않았을 때,
            // startTime == null 조건이 없으면 데이터들이 계속 바뀌기 때문에 setstate가 있는 색깔영역 터치가 안됨
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorID;
            }

            return SafeArea(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    child: Form(
                      //autovalidateMode: AutovalidateMode.always, //실시간 자동으로 validation
                      key: formkey, // 일종의 컨트롤러 역할 여기 페이지에서의 textform을 관리
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                            onStartSaved: (newValue) {
                              startTime = int.parse(newValue!);
                            },
                            onEndSaved: (newValue) {
                              endTime = int.parse(newValue!);
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          _Content(
                            initialValue: content ?? '',
                            onSaved: (newValue) {
                              content = newValue;
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          FutureBuilder<List<CategoryColor>>(
                              future:
                                  GetIt.I<LocalDatabase>().getCategoryColors(),
                              //local database를 getit을 이용해서 injection(의존성 주입)을 하는 것임!
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    selectedColorId == null &&
                                    snapshot.data!.isNotEmpty) {
                                  selectedColorId = snapshot.data![0].id;
                                }
                                return _ColorPicker(
                                  colorIdSetter: (int id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                  selectedColorId: selectedColorId,
                                  colors:
                                      snapshot.hasData ? snapshot.data! : [],
                                );
                              }),
                          SizedBox(
                            width: 8,
                          ),
                          _SaveButton(
                            onPressed: onSavePressed,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onSavePressed() async {
    //저장을 했을 때, formkey로 textfield들을 검증할 것임

    //formkey는 있는데 위젯과 결합을 안했을 때, (현재 구조에서는 Form 하위에 formkey를 넣어서
    // 발생하지는 않음)
    if (formkey.currentState == null) {
      return;
    }

    //하위의 모든 텍스트form필드의 에러를 확인함
    // textform필드들에서 각각 validator에서 에러가 있으면 null이 return 되어야 에러가 없는 것임

    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorID: Value(selectedColorId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorID: Value(selectedColorId!),
          ),
        );
      }

      Navigator.of(context).pop();
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time(
      {Key? key,
      required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          initialValue: startInitialValue,
          onSaved: onStartSaved,
          isTime: true,
          label: '시작 시간',
        )),
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: CustomTextField(
          initialValue: endInitialValue,
          onSaved: onEndSaved,
          isTime: true,
          label: '마감 시간',
        )),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({Key? key, required this.onSaved, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        initialValue: initialValue,
        onSaved: onSaved,
        label: '내용',
        isTime: false,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    Key? key,
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10.0,
      spacing: 8.0,
      children: colors
          .map((e) => GestureDetector(
                onTap: () {
                  colorIdSetter(e.id);
                },
                child: renderColor(
                  e,
                  selectedColorId == e.id,
                ),
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(int.parse(
          'FF${color.hexcode}',
          radix: 16,
        )),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4.0,
              )
            : null,
      ),
      width: 32.0,
      height: 32,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            onPressed: onPressed,
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
