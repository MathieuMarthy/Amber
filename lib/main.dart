import "package:flutter/material.dart";
import "package:dynamic_color/dynamic_color.dart";
import "package:amber_calendar/src/views/home_page.dart";
import "package:google_fonts/google_fonts.dart";

void main() {
  runApp(const Amber());
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
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            textTheme: _lightTextTheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            textTheme: _darkTextTheme,
          ),
          themeMode:
              ThemeMode.system, // Automatically switch based on system setting
          home: HomePage(isDynamic: lightDynamic != null),
        );
      },
    );
  }
}
