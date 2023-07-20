import 'package:calender_schedule/database/drift_database.dart';
import 'package:calender_schedule/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';

const DEFAULT_COLORS = [
  //빨강
  'F44336',
  //주황
  'FF9800',
  //노랑
  'FFEB3B',
  //초록
  'FCAF50',
  //파랑
  '2196F3',
  //남색
  '3F51B5',
  //보라
  '9C27B0'
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  //daatbase 클래스들을 인스턴스화해야함

  final database = LocalDatabase();

 // 하위에서 데이터 베이스 접근할수있게 해줌
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(CategoryColorsCompanion(
        hexcode: Value(hexCode), // CategoryColorsCompanion()의 클래스를 만들기 위해 Value<String>임!
      ));
    }
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: HomeScreen(),
    ),
  );
}
