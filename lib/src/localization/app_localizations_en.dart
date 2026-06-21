// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addSubscription => 'Add subscription';

  @override
  String get subscriptionName => 'Subscription name';

  @override
  String get subscriptionNameHint => 'e.g., Netflix, Spotify';

  @override
  String get validationNameRequired => 'Please enter a name';

  @override
  String get price => 'Price';

  @override
  String get priceHint => 'e.g., 9.99';

  @override
  String get validationPriceRequired => 'Please enter a price';

  @override
  String get validationPriceInvalid => 'Please enter a valid number';

  @override
  String get validationPriceNegative => 'Price cannot be negative';

  @override
  String get validationPriceDecimals => 'No more than 2 decimal places';

  @override
  String get firstPaymentDate => 'First payment date';

  @override
  String get repeatEvery => 'Repeat every';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get period => 'Period';

  @override
  String get days => 'Day(s)';

  @override
  String get weeks => 'Week(s)';

  @override
  String get months => 'Month(s)';

  @override
  String get years => 'Year(s)';

  @override
  String get category => 'Category';

  @override
  String get none => 'None';

  @override
  String get manageCategories => 'Manage categories';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Add details...';

  @override
  String errorCreating(String error) {
    return 'Error creating: $error';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get successToast => 'Subscription created successfully';
}
