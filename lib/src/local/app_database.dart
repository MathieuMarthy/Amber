import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:amber_calendar/src/local/local_category_dao.dart';
import 'package:amber_calendar/src/local/local_subscription_dao.dart';

part 'app_database.g.dart';

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

enum UnitOfTime { day, week, month, year }

// @DataClassName avoir conflict with dart:async Subscription
@DataClassName('SubscriptionEntry')
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get name => text()();
  IntColumn get price => integer()(); // en centimes (ex: 1799 = 17,99€)
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get startDay => dateTime()();
  IntColumn get frequency => integer()();
  IntColumn get unitOfTime => intEnum<UnitOfTime>()();
  IntColumn get repeatXTimes => integer().nullable()();
  DateTimeColumn get repeatUntil => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Categories, Subscriptions],
  daos: [LocalCategoryDao, LocalSubscriptionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'amber_calendar.db'));
    return NativeDatabase.createInBackground(file);
  });
}
