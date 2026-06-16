import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/local/local_subscription_dao.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SubscriptionRepository {
  final LocalSubscriptionDao _dao;
  static const _uuid = Uuid();

  SubscriptionRepository(this._dao);

  Future<List<SubscriptionEntry>> getAll() => _dao.getAll();
  Future<SubscriptionEntry?> getById(String id) => _dao.getById(id);

  Future<SubscriptionEntry> create({
    String? categoryId,
    required String name,
    required int price,
    String notes = '',
    required DateTime startDay,
    required int frequency,
    required int unitOfTime,
    int? repeatXTimes,
    DateTime? repeatUntil,
  }) async {
    assert(frequency > 0, 'frequency must be positive');
    assert(
      repeatXTimes == null || repeatXTimes > 0,
      'repeatXTimes must be positive',
    );

    final now = DateTime.now();
    final id = _uuid.v4();
    final companion = SubscriptionsCompanion.insert(
      id: id,
      categoryId: Value(categoryId),
      name: name,
      price: price,
      notes: Value(notes),
      startDay: startDay,
      frequency: frequency,
      unitOfTime: unitOfTime,
      repeatXTimes: Value(repeatXTimes),
      repeatUntil: Value(repeatUntil),
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insertOrUpdate(companion);
    return SubscriptionEntry(
      id: id,
      name: name,
      price: price,
      notes: notes,
      startDay: startDay,
      frequency: frequency,
      unitOfTime: unitOfTime,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<SubscriptionEntry> update(
    SubscriptionEntry sub, {
    String? name,
    int? price,
    String? notes,
    String? categoryId,
  }) async {
    final companion = SubscriptionsCompanion(
      id: Value(sub.id),
      name: Value(name ?? sub.name),
      price: Value(price ?? sub.price),
      notes: Value(notes ?? sub.notes),
      categoryId: Value(categoryId),
      startDay: Value(sub.startDay),
      frequency: Value(sub.frequency),
      unitOfTime: Value(sub.unitOfTime),
      repeatXTimes: Value(sub.repeatXTimes),
      repeatUntil: Value(sub.repeatUntil),
      createdAt: Value(sub.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _dao.insertOrUpdate(companion);
    return (await _dao.getById(sub.id))!;
  }

  Future<void> delete(String id) => _dao.deleteById(id);
}
