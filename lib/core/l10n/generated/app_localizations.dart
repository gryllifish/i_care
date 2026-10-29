import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ICare'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'ICare helps caregivers keep track together. It does not give medical advice: follow the instructions of the treating doctor or pharmacist.'**
  String get medicalDisclaimer;

  /// No description provided for @errorLoadData.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read the saved data.'**
  String get errorLoadData;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that item.'**
  String get errorNotFound;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Changes are saved on this device and sync when the connection is back.'**
  String get errorOffline;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'This is taking too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The sync service is having trouble. Try again soon.'**
  String get errorServer;

  /// No description provided for @sampleData.
  ///
  /// In en, this message translates to:
  /// **'Sample data'**
  String get sampleData;

  /// No description provided for @syncedAt.
  ///
  /// In en, this message translates to:
  /// **'Synced at {time}'**
  String syncedAt(String time);

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get syncNever;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get syncOffline;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change waiting to sync} other{{count} changes waiting to sync}}'**
  String syncPending(int count);

  /// No description provided for @nextDose.
  ///
  /// In en, this message translates to:
  /// **'Next dose'**
  String get nextDose;

  /// No description provided for @allDoneToday.
  ///
  /// In en, this message translates to:
  /// **'All of today\'s doses are recorded.'**
  String get allDoneToday;

  /// No description provided for @fromYesterday.
  ///
  /// In en, this message translates to:
  /// **'From yesterday'**
  String get fromYesterday;

  /// No description provided for @dayPartMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get dayPartMorning;

  /// No description provided for @dayPartMidday.
  ///
  /// In en, this message translates to:
  /// **'Midday'**
  String get dayPartMidday;

  /// No description provided for @dayPartAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get dayPartAfternoon;

  /// No description provided for @dayPartNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get dayPartNight;

  /// No description provided for @asNeeded.
  ///
  /// In en, this message translates to:
  /// **'As needed'**
  String get asNeeded;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusDue.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get statusDue;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusOverdue;

  /// No description provided for @statusGiven.
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get statusGiven;

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get statusSkipped;

  /// No description provided for @statusGivenTwice.
  ///
  /// In en, this message translates to:
  /// **'Given twice'**
  String get statusGivenTwice;

  /// No description provided for @recordedBy.
  ///
  /// In en, this message translates to:
  /// **'{name} at {time}'**
  String recordedBy(String name, String time);

  /// No description provided for @lastDose.
  ///
  /// In en, this message translates to:
  /// **'Last dose: {time}, by {name}'**
  String lastDose(String time, String name);

  /// No description provided for @noDoseYet.
  ///
  /// In en, this message translates to:
  /// **'No doses recorded'**
  String get noDoseYet;

  /// No description provided for @stockDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Runs out today} =1{1 day left} other{{days} days left}}'**
  String stockDays(int days);

  /// No description provided for @stockOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get stockOut;

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing to review} other{{count} things to review}}'**
  String toReview(int count);

  /// No description provided for @conflictDoseBody.
  ///
  /// In en, this message translates to:
  /// **'More than one person recorded this dose as given, without seeing the other record. Talk to them before the next dose.'**
  String get conflictDoseBody;

  /// No description provided for @doubleDoseBody.
  ///
  /// In en, this message translates to:
  /// **'Recorded as given more than once, on purpose.'**
  String get doubleDoseBody;

  /// No description provided for @markReviewed.
  ///
  /// In en, this message translates to:
  /// **'Mark as reviewed'**
  String get markReviewed;

  /// No description provided for @markGiven.
  ///
  /// In en, this message translates to:
  /// **'Mark as given'**
  String get markGiven;

  /// No description provided for @markGivenAnyway.
  ///
  /// In en, this message translates to:
  /// **'Mark as given anyway'**
  String get markGivenAnyway;

  /// No description provided for @skipDose.
  ///
  /// In en, this message translates to:
  /// **'Skip this dose'**
  String get skipDose;

  /// No description provided for @skipReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Why is it skipped?'**
  String get skipReasonTitle;

  /// No description provided for @skipRefused.
  ///
  /// In en, this message translates to:
  /// **'Refused it'**
  String get skipRefused;

  /// No description provided for @skipAsleep.
  ///
  /// In en, this message translates to:
  /// **'Was asleep'**
  String get skipAsleep;

  /// No description provided for @skipUnwell.
  ///
  /// In en, this message translates to:
  /// **'Felt unwell'**
  String get skipUnwell;

  /// No description provided for @skipDoctorAdvice.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s advice'**
  String get skipDoctorAdvice;

  /// No description provided for @skipOther.
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get skipOther;

  /// No description provided for @skippedBy.
  ///
  /// In en, this message translates to:
  /// **'Skipped by {name}: {reason}'**
  String skippedBy(String name, String reason);

  /// No description provided for @doseRecordedGiven.
  ///
  /// In en, this message translates to:
  /// **'{medication} recorded as given'**
  String doseRecordedGiven(String medication);

  /// No description provided for @doseRecordedSkipped.
  ///
  /// In en, this message translates to:
  /// **'{medication} recorded as skipped'**
  String doseRecordedSkipped(String medication);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @checkBeforeGiving.
  ///
  /// In en, this message translates to:
  /// **'Check before giving it'**
  String get checkBeforeGiving;

  /// No description provided for @warningAlreadyGiven.
  ///
  /// In en, this message translates to:
  /// **'{name} already recorded it at {time}.'**
  String warningAlreadyGiven(String name, String time);

  /// No description provided for @warningTooSoon.
  ///
  /// In en, this message translates to:
  /// **'The last dose was at {last}. With the interval you entered, the next one is from {next}.'**
  String warningTooSoon(String last, String next);

  /// No description provided for @warningDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'{given} of {max} doses given today, the maximum you entered.'**
  String warningDailyLimit(int given, int max);

  /// No description provided for @warningOutOfDate.
  ///
  /// In en, this message translates to:
  /// **'This phone last synced at {time}: someone may have given it already.'**
  String warningOutOfDate(String time);

  /// No description provided for @warningNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'This phone has not synced yet: someone may have given it already.'**
  String get warningNeverSynced;

  /// No description provided for @scheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Scheduled at {time}'**
  String scheduledAt(String time);

  /// No description provided for @recordedToday.
  ///
  /// In en, this message translates to:
  /// **'Recorded today'**
  String get recordedToday;

  /// No description provided for @recordedForThisDose.
  ///
  /// In en, this message translates to:
  /// **'Recorded for this dose'**
  String get recordedForThisDose;

  /// No description provided for @unknownCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get unknownCaregiver;

  /// No description provided for @whoAreYou.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get whoAreYou;

  /// No description provided for @phoneOf.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s phone'**
  String phoneOf(String name);

  /// No description provided for @networkOn.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get networkOn;

  /// No description provided for @networkOff.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get networkOff;

  /// No description provided for @demoHint.
  ///
  /// In en, this message translates to:
  /// **'Two caregivers\' phones, synced through a simulated server. Turn one offline and record the same dose on both.'**
  String get demoHint;

  /// No description provided for @careOf.
  ///
  /// In en, this message translates to:
  /// **'Caring for {name}'**
  String careOf(String name);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @notSyncedYet.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get notSyncedYet;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
