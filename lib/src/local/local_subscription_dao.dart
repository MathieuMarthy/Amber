import 'package:drift/drift.dart';
import 'app_database.dart';

part 'local_subscription_dao.g.dart';

@DriftAccessor(tables: [Subscriptions])
class LocalSubscriptionDao extends DatabaseAccessor<AppDatabase>
    with _$LocalSubscriptionDaoMixin {
  LocalSubscriptionDao(super.db);

  Future<List<SubscriptionEntry>> getAll() =>
      (select(subscriptions)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Future<SubscriptionEntry?> getById(String id) =>
      (select(subscriptions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertOrUpdate(SubscriptionsCompanion companion) =>
      into(subscriptions).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) =>
      (delete(subscriptions)..where((t) => t.id.equals(id))).go();
}
