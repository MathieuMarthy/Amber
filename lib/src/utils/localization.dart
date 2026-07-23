import 'package:flutter/widgets.dart';
import 'package:amber_calendar/src/localization/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
