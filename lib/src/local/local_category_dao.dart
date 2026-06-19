import 'package:drift/drift.dart';
import 'app_database.dart';

part 'local_category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class LocalCategoryDao extends DatabaseAccessor<AppDatabase>
    with _$LocalCategoryDaoMixin {
  LocalCategoryDao(super.db);

  Future<List<Category>> getAll() =>
      (select(categories)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Future<Category?> getById(String id) =>
      (select(categories)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertOrUpdate(CategoriesCompanion companion) =>
      into(categories).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) async {
    await transaction(() async {
      await (update(db.subscriptions)..where((t) => t.categoryId.equals(id)))
          .write(const SubscriptionsCompanion(categoryId: Value(null)));
      await (delete(categories)..where((t) => t.id.equals(id))).go();
    });
  }
}
