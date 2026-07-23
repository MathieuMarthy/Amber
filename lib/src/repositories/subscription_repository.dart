import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/local/local_subscription_dao.dart';
import 'package:amber_calendar/src/utils/date_utils.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SubscriptionRepository {
  final LocalSubscriptionDao _dao;
  static const _uuid = Uuid();

  SubscriptionRepository(this._dao);

  Future<List<SubscriptionEntry>> getAll({bool? activeOnly}) async {
    final all = await _dao.getAll();
    if (activeOnly == null) return all;
    return all
        .where((sub) => activeOnly ? isActive(sub) : !isActive(sub))
        .toList();
  }

  Future<SubscriptionEntry?> getById(String id) => _dao.getById(id);

  /// Returns both the subscriptions and the total amount due for a given month.
  /// This optimizes performance by fetching `getAll()` only once.
  Future<({List<SubscriptionEntry> subscriptions, int totalCents})>
  getMonthSummary(DateTime date) async {
    final monthStart = DateTime(date.year, date.month, 1);
    final monthEnd = DateTime(date.year, date.month + 1, 0);
    final allSubs = await getAll();

    final subscriptions = <SubscriptionEntry>[];
    int totalCents = 0;

    for (final sub in allSubs) {
      final occurrences = getPaymentDaysInRange(
        sub,
        monthStart,
        monthEnd,
      ).length;
      if (occurrences > 0) {
        subscriptions.add(sub);
        totalCents += sub.price * occurrences;
      }
    }

    return (subscriptions: subscriptions, totalCents: totalCents);
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
    // Provide a way to clear categoryId/websiteUrl. If we just pass null, we don't know if the caller meant "no change" or "clear".
    // We'll use a `clearCategory` and `clearWebsiteUrl` boolean flag for simplicity.
    String? categoryId,
    bool clearCategory = false,
    String? websiteUrl,
    bool clearWebsiteUrl = false,
    DateTime? startDay,
    int? frequency,
    int? unitOfTime,
    int? repeatXTimes,
    bool clearRepeatXTimes = false,
    DateTime? repeatUntil,
    bool clearRepeatUntil = false,
  }) async {
    final companion = SubscriptionsCompanion(
      id: Value(sub.id),
      name: Value(name ?? sub.name),
      price: Value(price ?? sub.price),
      notes: Value(notes ?? sub.notes),
      websiteUrl: clearWebsiteUrl
          ? const Value(null)
          : (websiteUrl != null ? Value(websiteUrl) : Value(sub.websiteUrl)),
      categoryId: clearCategory
          ? const Value(null)
          : (categoryId != null ? Value(categoryId) : Value(sub.categoryId)),
      startDay: Value(startDay ?? sub.startDay),
      frequency: Value(frequency ?? sub.frequency),
      unitOfTime: Value(
        unitOfTime != null ? UnitOfTime.values[unitOfTime] : sub.unitOfTime,
      ),
      repeatXTimes: clearRepeatXTimes
          ? const Value(null)
          : (repeatXTimes != null
                ? Value(repeatXTimes)
                : Value(sub.repeatXTimes)),
      repeatUntil: clearRepeatUntil
          ? const Value(null)
          : (repeatUntil != null ? Value(repeatUntil) : Value(sub.repeatUntil)),
      createdAt: Value(sub.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _dao.insertOrUpdate(companion);
    return (await _dao.getById(sub.id))!;
  }

  // cancel = stopper sans supprimer
  Future<void> cancel(String id) async {
    final sub = (await _dao.getById(id))!;
    final companion = sub
        .toCompanion(false)
        .copyWith(
          cancelledAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        );
    await _dao.insertOrUpdate(companion);
  }

  // reactivate = remettre cancelledAt à null
  Future<void> reactivate(String id) async {
    final sub = (await _dao.getById(id))!;
    final companion = sub
        .toCompanion(false)
        .copyWith(
          cancelledAt: const Value(null),
          updatedAt: Value(DateTime.now()),
        );
    await _dao.insertOrUpdate(companion);
  }

  Future<void> delete(String id) => _dao.deleteById(id);
}
