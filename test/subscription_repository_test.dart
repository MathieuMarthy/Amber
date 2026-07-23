import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SubscriptionRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = SubscriptionRepository(db.localSubscriptionDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('SubscriptionRepository - getByMonth', () {
    test('retrieves subscription that starts in the target month', () async {
      final sub = await repository.create(
        name: 'Netflix',
        price: 1799,
        startDay: DateTime(2026, 6, 15),
        frequency: 1,
        unitOfTime: UnitOfTime.month.index,
      );

      final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
      final result = summary.subscriptions;
      expect(result.length, 1);
      expect(result.first.id, sub.id);
    });

    test(
      'retrieves subscription that starts before and repeats indefinitely',
      () async {
        final sub = await repository.create(
          name: 'Spotify',
          price: 999,
          startDay: DateTime(2026, 1, 1),
          frequency: 1,
          unitOfTime: UnitOfTime.month.index,
        );

        final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
        final result = summary.subscriptions;
        expect(result.length, 1);
        expect(result.first.id, sub.id);
      },
    );

    test('does not retrieve subscription that starts in the future', () async {
      await repository.create(
        name: 'Future Sub',
        price: 500,
        startDay: DateTime(2026, 7, 1),
        frequency: 1,
        unitOfTime: UnitOfTime.month.index,
      );

      final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
      final result = summary.subscriptions;
      expect(result.isEmpty, true);
    });

    test(
      'does not retrieve subscription that ended before the target month via repeatUntil',
      () async {
        await repository.create(
          name: 'Ended Sub',
          price: 1000,
          startDay: DateTime(2026, 1, 1),
          frequency: 1,
          unitOfTime: UnitOfTime.month.index,
          repeatUntil: DateTime(2026, 5, 15),
        );

        final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
        final result = summary.subscriptions;
        expect(result.isEmpty, true);
      },
    );

    test(
      'retrieves subscription that ends during the target month via repeatUntil',
      () async {
        final sub = await repository.create(
          name: 'Ending Sub',
          price: 1000,
          startDay: DateTime(2026, 1, 1),
          frequency: 1,
          unitOfTime: UnitOfTime.month.index,
          repeatUntil: DateTime(2026, 6, 10),
        );

        final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
        final result = summary.subscriptions;
        expect(result.length, 1);
        expect(result.first.id, sub.id);
      },
    );

    test(
      'does not retrieve subscription that ended before target month via repeatXTimes',
      () async {
        // Starts Jan 1st, 2026. Frequency: 1 Month. Repeat 3 times (ends April 1st, 2026)
        await repository.create(
          name: 'Limited Sub',
          price: 1200,
          startDay: DateTime(2026, 1, 1),
          frequency: 1,
          unitOfTime: UnitOfTime.month.index,
          repeatXTimes: 3,
        );

        // Checking June 2026
        final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
        final result = summary.subscriptions;
        expect(result.isEmpty, true);
      },
    );

    test(
      'retrieves subscription active during target month via repeatXTimes',
      () async {
        // Starts May 15, 2026. Frequency: 1 Month. Repeat 2 times (ends July 15, 2026)
        final sub = await repository.create(
          name: 'Active Limited Sub',
          price: 1200,
          startDay: DateTime(2026, 5, 15),
          frequency: 1,
          unitOfTime: UnitOfTime.month.index,
          repeatXTimes: 2,
        );

        // Checking June 2026
        final summary = await repository.getMonthSummary(DateTime(2026, 6, 1));
        final result = summary.subscriptions;
        expect(result.length, 1);
        expect(result.first.id, sub.id);
      },
    );
  });
}
