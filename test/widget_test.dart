import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/category_repository.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:amber_calendar/src/widgets/add_subscription.dart';
import 'package:amber_calendar/src/localization/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('AddSubscription form renders with correct fields',
      (WidgetTester tester) async {
    // Create an in-memory database for testing
    final db =
        AppDatabase.forTesting(NativeDatabase.memory());
    final categoryRepo = CategoryRepository(db.localCategoryDao);
    final subscriptionRepo = SubscriptionRepository(db.localSubscriptionDao);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: db),
          Provider<CategoryRepository>.value(value: categoryRepo),
          Provider<SubscriptionRepository>.value(value: subscriptionRepo),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: Scaffold(
            body: SingleChildScrollView(
              child: AddSubscription(),
            ),
          ),
        ),
      ),
    );

    // Wait for the category loading future to complete and pump
    await tester.pumpAndSettle();

    // Verify UI components are rendered
    expect(find.text('Ajouter un abonnement'), findsOneWidget);
    expect(find.text('Nom de l\'abonnement'), findsOneWidget);
    expect(find.text('Prix'), findsOneWidget);
    expect(find.text('Date du premier paiement'), findsOneWidget);
    expect(find.text('Répéter tous les'), findsOneWidget);
    expect(find.text('Période'), findsOneWidget);
    expect(find.text('Catégorie'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);

    await db.close();
  });
}


