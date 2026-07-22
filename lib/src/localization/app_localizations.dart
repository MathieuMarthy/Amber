import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @addSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un abonnement'**
  String get addSubscription;

  /// No description provided for @editSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'abonnement'**
  String get editSubscription;

  /// No description provided for @subscriptionName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'abonnement'**
  String get subscriptionName;

  /// No description provided for @subscriptionNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Netflix, Spotify'**
  String get subscriptionNameHint;

  /// No description provided for @validationNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un nom'**
  String get validationNameRequired;

  /// No description provided for @price.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get price;

  /// No description provided for @priceHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: 9.99'**
  String get priceHint;

  /// No description provided for @validationPriceRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un prix'**
  String get validationPriceRequired;

  /// No description provided for @validationPriceInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un nombre valide'**
  String get validationPriceInvalid;

  /// No description provided for @validationPriceNegative.
  ///
  /// In fr, this message translates to:
  /// **'Le prix ne peut pas être négatif'**
  String get validationPriceNegative;

  /// No description provided for @validationPriceDecimals.
  ///
  /// In fr, this message translates to:
  /// **'Pas plus de 2 décimales'**
  String get validationPriceDecimals;

  /// No description provided for @firstPaymentDate.
  ///
  /// In fr, this message translates to:
  /// **'Date du premier paiement'**
  String get firstPaymentDate;

  /// No description provided for @repeatEvery.
  ///
  /// In fr, this message translates to:
  /// **'Répéter tous les'**
  String get repeatEvery;

  /// No description provided for @required.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get required;

  /// No description provided for @invalid.
  ///
  /// In fr, this message translates to:
  /// **'Invalide'**
  String get invalid;

  /// No description provided for @period.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get period;

  /// No description provided for @days.
  ///
  /// In fr, this message translates to:
  /// **'Jour(s)'**
  String get days;

  /// No description provided for @weeks.
  ///
  /// In fr, this message translates to:
  /// **'Semaine(s)'**
  String get weeks;

  /// No description provided for @months.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get months;

  /// No description provided for @years.
  ///
  /// In fr, this message translates to:
  /// **'An(s)'**
  String get years;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @none.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get none;

  /// No description provided for @manageCategories.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les catégories'**
  String get manageCategories;

  /// No description provided for @notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter des détails...'**
  String get notesHint;

  /// No description provided for @errorCreating.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création : {error}'**
  String errorCreating(String error);

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @successToast.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement créé avec succès'**
  String get successToast;

  /// No description provided for @websiteUrl.
  ///
  /// In fr, this message translates to:
  /// **'URL du site (optionnel)'**
  String get websiteUrl;

  /// No description provided for @websiteUrlHint.
  ///
  /// In fr, this message translates to:
  /// **'https://netflix.com'**
  String get websiteUrlHint;

  /// No description provided for @websiteUrlTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Entrez l\'URL du site pour afficher automatiquement le logo du service (ex : https://netflix.com)'**
  String get websiteUrlTooltip;

  /// No description provided for @paymentThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Paiement ce mois-ci'**
  String get paymentThisMonth;

  /// No description provided for @recurrenceDays.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Tous les jours} other{Tous les {count} jours}}'**
  String recurrenceDays(int count);

  /// No description provided for @recurrenceWeeks.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Toutes les semaines} other{Toutes les {count} semaines}}'**
  String recurrenceWeeks(int count);

  /// No description provided for @recurrenceMonths.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Tous les mois, le {day}} other{Tous les {count} mois, le {day}}}'**
  String recurrenceMonths(int count, int day);

  /// No description provided for @recurrenceYears.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Tous les ans} other{Tous les {count} ans}}'**
  String recurrenceYears(int count);

  /// No description provided for @subscriptionDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de l\'abonnement'**
  String get subscriptionDetails;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @deleteSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'abonnement'**
  String get deleteSubscription;

  /// No description provided for @deleteConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cet abonnement ?'**
  String get deleteConfirmation;

  /// No description provided for @successUpdateToast.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement modifié avec succès'**
  String get successUpdateToast;

  /// No description provided for @successDeleteToast.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement supprimé avec succès'**
  String get successDeleteToast;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
