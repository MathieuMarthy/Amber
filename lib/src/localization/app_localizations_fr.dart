// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get addSubscription => 'Ajouter un abonnement';

  @override
  String get subscriptionName => 'Nom de l\'abonnement';

  @override
  String get subscriptionNameHint => 'ex: Netflix, Spotify';

  @override
  String get validationNameRequired => 'Veuillez saisir un nom';

  @override
  String get price => 'Prix';

  @override
  String get priceHint => 'ex: 9.99';

  @override
  String get validationPriceRequired => 'Veuillez saisir un prix';

  @override
  String get validationPriceInvalid => 'Veuillez saisir un nombre valide';

  @override
  String get validationPriceNegative => 'Le prix ne peut pas être négatif';

  @override
  String get validationPriceDecimals => 'Pas plus de 2 décimales';

  @override
  String get firstPaymentDate => 'Date du premier paiement';

  @override
  String get repeatEvery => 'Répéter tous les';

  @override
  String get required => 'Requis';

  @override
  String get invalid => 'Invalide';

  @override
  String get period => 'Période';

  @override
  String get days => 'Jour(s)';

  @override
  String get weeks => 'Semaine(s)';

  @override
  String get months => 'Mois';

  @override
  String get years => 'An(s)';

  @override
  String get category => 'Catégorie';

  @override
  String get none => 'Aucune';

  @override
  String get manageCategories => 'Gérer les catégories';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Ajouter des détails...';

  @override
  String errorCreating(String error) {
    return 'Erreur lors de la création : $error';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get successToast => 'Abonnement créé avec succès';
}
