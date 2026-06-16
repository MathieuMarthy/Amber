// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_category_dao.dart';

// ignore_for_file: type=lint
mixin _$LocalCategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  LocalCategoryDaoManager get managers => LocalCategoryDaoManager(this);
}

class LocalCategoryDaoManager {
  final _$LocalCategoryDaoMixin _db;
  LocalCategoryDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
}
