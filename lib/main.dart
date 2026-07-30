import "package:amber_calendar/src/local/app_database.dart";
import "package:amber_calendar/src/repositories/category_repository.dart";
import "package:amber_calendar/src/repositories/subscription_repository.dart";
import "package:flutter/material.dart";
import "package:dynamic_color/dynamic_color.dart";
import "package:amber_calendar/src/views/root_page.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:amber_calendar/src/localization/app_localizations.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:amber_calendar/src/providers/settings_provider.dart";
import "package:flutter_phoenix/flutter_phoenix.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(prefs),
          ),
          Provider<AppDatabase>(
            create: (_) => AppDatabase(),
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
    final settings = context.watch<SettingsProvider>();

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
          themeMode: settings.themeMode,
          home: const RootPage(),
        );
      },
    );
  }
}
