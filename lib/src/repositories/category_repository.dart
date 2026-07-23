import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/local/local_category_dao.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository {
  final LocalCategoryDao _dao;
  static const _uuid = Uuid();

  CategoryRepository(this._dao);

  Future<List<Category>> getAll() => _dao.getAll();
  Future<Category?> getById(String id) => _dao.getById(id);

  Future<Category> create(String name) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    final companion = CategoriesCompanion.insert(
      id: id,
      name: name,
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insertOrUpdate(companion);
    return Category(id: id, name: name, createdAt: now, updatedAt: now);
  }

  Future<Category> update(Category category, {String? name}) async {
    final companion = CategoriesCompanion(
      id: Value(category.id),
      name: Value(name ?? category.name),
      createdAt: Value(category.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _dao.insertOrUpdate(companion);
    return (await _dao.getById(category.id))!;
  }

  Future<void> delete(String id) => _dao.deleteById(id);
}
