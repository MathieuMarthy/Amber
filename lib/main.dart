import "package:amber_calendar/src/local/app_database.dart";
import "package:amber_calendar/src/repositories/category_repository.dart";
import "package:amber_calendar/src/repositories/subscription_repository.dart";
import "package:flutter/material.dart";
import "package:dynamic_color/dynamic_color.dart";
import "package:amber_calendar/src/views/home_page.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:amber_calendar/src/localization/app_localizations.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => database,
          dispose: (_, db) => db.close(),
        ),
        Provider<CategoryRepository>(
          create: (ctx) =>
              CategoryRepository(ctx.read<AppDatabase>().localCategoryDao),
        ),
        Provider<SubscriptionRepository>(
          create: (ctx) => SubscriptionRepository(
            ctx.read<AppDatabase>().localSubscriptionDao,
          ),
        ),
      ],
      child: const Amber(),
    ),
  );
}

class Amber extends StatelessWidget {
  const Amber({super.key});

  static const _defaultLightSeed = Colors.indigo;
  static const _defaultDarkSeed = Colors.indigo;

  static final _lightTextTheme = GoogleFonts.googleSansFlexTextTheme(
    Typography.material2021().black,
  );
  static final _darkTextTheme = GoogleFonts.googleSansFlexTextTheme(
    Typography.material2021().white,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // Material You is available
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // use default colors
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _defaultLightSeed,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _defaultDarkSeed,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: "Amber",
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            textTheme: _lightTextTheme,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            textTheme: _darkTextTheme,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode:
              ThemeMode.system, // Automatically switch based on system setting
          home: HomePage(isDynamic: lightDynamic != null),
        );
      },
    );
  }
}
