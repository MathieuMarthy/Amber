// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_subscription_dao.dart';

// ignore_for_file: type=lint
mixin _$LocalSubscriptionDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $SubscriptionsTable get subscriptions => attachedDatabase.subscriptions;
  LocalSubscriptionDaoManager get managers => LocalSubscriptionDaoManager(this);
}

class LocalSubscriptionDaoManager {
  final _$LocalSubscriptionDaoMixin _db;
  LocalSubscriptionDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db.attachedDatabase, _db.subscriptions);
}
