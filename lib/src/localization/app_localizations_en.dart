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
  String get editSubscription => 'Edit subscription';

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

  @override
  String get websiteUrl => 'Website URL (optional)';

  @override
  String get websiteUrlHint => 'https://netflix.com';

  @override
  String get websiteUrlTooltip =>
      'Enter the website URL to automatically display the service logo (e.g. https://netflix.com)';

  @override
  String get paymentThisMonth => 'Payment this month';

  @override
  String recurrenceDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String recurrenceWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Every week',
    );
    return '$_temp0';
  }

  @override
  String recurrenceMonths(int count, int day) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months, on the $day',
      one: 'Every month, on the $day',
    );
    return '$_temp0';
  }

  @override
  String recurrenceYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Every year',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetails => 'Subscription details';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSubscription => 'Delete subscription';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this subscription?';

  @override
  String get successUpdateToast => 'Subscription updated successfully';

  @override
  String get successDeleteToast => 'Subscription deleted successfully';

  @override
  String get home => 'Home';

  @override
  String get allSubscriptions => 'All subscriptions';

  @override
  String get noSubscriptions => 'No subscriptions yet';

  @override
  String inactiveSince(String date) {
    return 'Inactive since $date';
  }

  @override
  String get inactive => 'Inactive';

  @override
  String get stopSubscription => 'Stop subscription';

  @override
  String get stopConfirmation =>
      'Do you want to stop this subscription? It will be kept in history.';

  @override
  String get stop => 'Stop';

  @override
  String get successStopToast => 'Subscription stopped';

  @override
  String get reactivateSubscription => 'Reactivate';

  @override
  String get successReactivateToast => 'Subscription reactivated';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterInactive => 'Inactive';

  @override
  String get endCondition => 'Stop condition';

  @override
  String get never => 'Never';

  @override
  String get onSpecificDate => 'On a specific date';

  @override
  String get afterXPayments => 'After X payments';

  @override
  String get endDate => 'End date';

  @override
  String get selectDate => 'Select a date';

  @override
  String get numberOfPayments => 'Number of payments';

  @override
  String endAfterPayments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'After $count payments',
      one: 'After 1 payment',
    );
    return '$_temp0';
  }
}
