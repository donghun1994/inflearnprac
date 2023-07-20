import 'package:drift/drift.dart';

class CategoryColors extends Table {

  //PRIMARY_COLOR_ID
  IntColumn get id => integer().autoIncrement()();

  //색상 코드
  TextColumn get hexcode => text()();

}