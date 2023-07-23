// SQL을 drift와 연결 생성하는 부분임

// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:calender_schedule/model/category_color.dart';
import 'package:calender_schedule/model/schedule.dart';
import 'package:calender_schedule/model/schedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 값까지 불러올 수 있다. 코드가 너무 많아서 사실상 같은 파일로 보게끔 하는..
// g는 자동으로 drift_database가 생김(커맨드 하나 터미널에 입력 -> flutter pub run build_runner build)
// 아래 파일은 작성한 시점에는 없음
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)

// _$LocalDatabase은 drift_database.g.dart에 있는 private class
// 데이터 베이스 클래스를 선언하는데 g.dart에 선언될 _$LocalDatabase를 상속받음
// 연결할 때는 어디에 저장할건지가 필요함
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // insert 쿼리
  // SchedulesCompanion 클래스에 Value 클래스에 감싸져 있는 row의 값들로 넣어야 db insert가 됨
  // into(테이블).insert(data) / createSchedule() 안의 param으로 SchedulesCompanion 클래스로 넣으면 인서트 되는 함수!
  // insert를 하면 자동으로 id(primary 값)을 받을 수 있음(Future<int>)

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // select 쿼리
  // future로 한 번에 받거나 stream으로 하나씩 순차적으로 값들을 계속 받아올 수 있음

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  //delete
  // go()는 모든 row들이 삭제됨
  // id 값에 해당하는 row만 삭제

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  Stream<List<ScheduleWithColor>> watchScedules(DateTime date) {
    // 날짜값을 기준으로 조회해서 데이터 반환 +  색깔하고 조인,
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorID))
    ]);

    query.where(schedules.date.equals(date));
    query.orderBy([OrderingTerm.asc(schedules.startTime)]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );

    // ..은 실행이 된 대상을 반환함(where은 원래 void를 반환하는데 오히려 대상이 되는 schedules가 필요하기때문에 ..을 사용함)
    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  // update 스케쥴

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      //schedules 테이블 update 할건데 선택한 row의 id의 데이터를 가져와서 새로 들어온 data로 write 해라!
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  // 데이터 베이스들의 상태 버전 / 테이블의 column이나 구조가 변경되면 버전을 바꿔줘야함
  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 2;
}

// 하드드라이브에 어디에 연결을 할지
LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase(file);
    },
  );
}
