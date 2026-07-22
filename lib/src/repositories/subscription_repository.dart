import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/local/local_subscription_dao.dart';
import 'package:amber_calendar/src/utils/date_utils.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SubscriptionRepository {
  final LocalSubscriptionDao _dao;
  static const _uuid = Uuid();

  SubscriptionRepository(this._dao);

  Future<List<SubscriptionEntry>> getAll() => _dao.getAll();
  Future<SubscriptionEntry?> getById(String id) => _dao.getById(id);

  Future<List<SubscriptionEntry>> getByMonth(DateTime date) async {
    final monthStart = DateTime(date.year, date.month, 1);
    final monthEnd = DateTime(date.year, date.month + 1, 0); // last day of month
    final allSubs = await getAll();

    return allSubs.where((sub) {
      return getPaymentDaysInRange(sub, monthStart, monthEnd).isNotEmpty;
    }).toList();
  }

  /// Returns a map of {normalizedDate: [subscriptions]} for the given date range.
  /// Each day holds at most 3 subscriptions (for calendar dot display).
  Future<Map<DateTime, List<SubscriptionEntry>>> getPaymentDayMap(
    DateTime rangeStart,
    DateTime rangeEnd,
  ) async {
    final allSubs = await getAll();
    final map = <DateTime, List<SubscriptionEntry>>{};

    for (final sub in allSubs) {
      final days = getPaymentDaysInRange(sub, rangeStart, rangeEnd);
      for (final day in days) {
        final list = map.putIfAbsent(day, () => []);
        if (list.length < 3) list.add(sub);
      }
    }
    return map;
  }

  Future<SubscriptionEntry> create({
    String? categoryId,
    required String name,
    required int price,
    String notes = '',
    String? websiteUrl,
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
      websiteUrl: Value(websiteUrl),
      startDay: startDay,
      frequency: frequency,
      unitOfTime: UnitOfTime.values[unitOfTime],
      repeatXTimes: Value(repeatXTimes),
      repeatUntil: Value(repeatUntil),
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insertOrUpdate(companion);
    return (await _dao.getById(id))!;
  }

  Future<SubscriptionEntry> update(
    SubscriptionEntry sub, {
    String? name,
    int? price,
    String? notes,
    String? categoryId,
    String? websiteUrl,
  }) async {
    final companion = SubscriptionsCompanion(
      id: Value(sub.id),
      name: Value(name ?? sub.name),
      price: Value(price ?? sub.price),
      notes: Value(notes ?? sub.notes),
      websiteUrl: Value(websiteUrl ?? sub.websiteUrl),
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
