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
  String get editSubscription => 'Modifier l\'abonnement';

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

  @override
  String get websiteUrl => 'URL du site (optionnel)';

  @override
  String get websiteUrlHint => 'https://netflix.com';

  @override
  String get websiteUrlTooltip =>
      'Entrez l\'URL du site pour afficher automatiquement le logo du service (ex : https://netflix.com)';

  @override
  String get paymentThisMonth => 'Paiement ce mois-ci';

  @override
  String recurrenceDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tous les $count jours',
      one: 'Tous les jours',
    );
    return '$_temp0';
  }

  @override
  String recurrenceWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toutes les $count semaines',
      one: 'Toutes les semaines',
    );
    return '$_temp0';
  }

  @override
  String recurrenceMonths(int count, int day) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tous les $count mois, le $day',
      one: 'Tous les mois, le $day',
    );
    return '$_temp0';
  }

  @override
  String recurrenceYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tous les $count ans',
      one: 'Tous les ans',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetails => 'Détails de l\'abonnement';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteSubscription => 'Supprimer l\'abonnement';

  @override
  String get deleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet abonnement ?';

  @override
  String get successUpdateToast => 'Abonnement modifié avec succès';

  @override
  String get successDeleteToast => 'Abonnement supprimé avec succès';

  @override
  String get home => 'Accueil';

  @override
  String get allSubscriptions => 'Abonnements';

  @override
  String get noSubscriptions => 'Aucun abonnement pour l\'instant';

  @override
  String inactiveSince(String date) {
    return 'Inactif depuis le $date';
  }

  @override
  String get inactive => 'Inactif';

  @override
  String get stopSubscription => 'Arrêter l\'abonnement';

  @override
  String get stopConfirmation =>
      'Voulez-vous arrêter cet abonnement ? Il sera conservé dans l\'historique.';

  @override
  String get stop => 'Arrêter';

  @override
  String get successStopToast => 'Abonnement arrêté';

  @override
  String get reactivateSubscription => 'Réactiver';

  @override
  String get successReactivateToast => 'Abonnement réactivé';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterActive => 'Actifs';

  @override
  String get filterInactive => 'Inactifs';

  @override
  String get endCondition => 'Condition d\'arrêt';

  @override
  String get never => 'Jamais';

  @override
  String get onSpecificDate => 'À une date précise';

  @override
  String get afterXPayments => 'Après X paiements';

  @override
  String get endDate => 'Date de fin';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get numberOfPayments => 'Nombre de paiements';

  @override
  String endAfterPayments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Après $count paiements',
      one: 'Après 1 paiement',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get currency => 'Devise';

  @override
  String get exportDatabase => 'Exporter la base de données';

  @override
  String get importDatabase => 'Importer une base de données';

  @override
  String get importWarning =>
      'L\'importation d\'une base de données effacera toutes vos données actuelles. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get importSuccess => 'Base de données importée avec succès.';

  @override
  String get exportError => 'Échec de l\'exportation de la base de données.';

  @override
  String get importError => 'Échec de l\'importation de la base de données.';

  @override
  String get dataManagement => 'Données';
}
