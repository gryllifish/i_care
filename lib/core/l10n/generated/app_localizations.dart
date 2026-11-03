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

  /// No description provided for @doubleDoseBody.
  ///
  /// In en, this message translates to:
  /// **'Recorded as given more than once. If in doubt, ask the doctor or pharmacist.'**
  String get doubleDoseBody;

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

  /// No description provided for @givenToo.
  ///
  /// In en, this message translates to:
  /// **'I gave it too'**
  String get givenToo;

  /// No description provided for @removeRecordOf.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}\'s record'**
  String removeRecordOf(String name);

  /// No description provided for @removeRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this record?'**
  String get removeRecordTitle;

  /// No description provided for @removeGivenBody.
  ///
  /// In en, this message translates to:
  /// **'{name} recorded it as given at {time}. Remove it only if the dose was not given. The change shows in Activity.'**
  String removeGivenBody(String name, String time);

  /// No description provided for @removeSkippedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} recorded it as skipped. Remove it if the dose is still to be given. The change shows in Activity.'**
  String removeSkippedBody(String name);

  /// No description provided for @recordRemoved.
  ///
  /// In en, this message translates to:
  /// **'Record removed'**
  String get recordRemoved;

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
  /// **'Two phones synced through a simulated server: Ana coordinates as admin, Rosa helps with today\'s care. To simulate a dose recorded twice: turn Rosa\'s phone off, mark the same dose on both and turn it back on. Ana reviews it.'**
  String get demoHint;

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

  /// No description provided for @conflictSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'{medication} at {time} was recorded {count} times'**
  String conflictSlotTitle(String medication, String time, int count);

  /// No description provided for @conflictCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'{medication}: doses too close together'**
  String conflictCloseTitle(String medication);

  /// No description provided for @conflictExplanation.
  ///
  /// In en, this message translates to:
  /// **'They were recorded on different phones, without seeing each other\'s record.'**
  String get conflictExplanation;

  /// No description provided for @conflictQuestion.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{Did {name} get both doses?} other{Did {name} get all {count} doses?}}'**
  String conflictQuestion(String name, int count);

  /// No description provided for @conflictOnlyOne.
  ///
  /// In en, this message translates to:
  /// **'No, only one'**
  String get conflictOnlyOne;

  /// No description provided for @conflictAllGiven.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{Yes, both were given} other{Yes, all were given}}'**
  String conflictAllGiven(int count);

  /// No description provided for @conflictNotSure.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know yet'**
  String get conflictNotSure;

  /// No description provided for @conflictResolvedOne.
  ///
  /// In en, this message translates to:
  /// **'Repeated record cancelled'**
  String get conflictResolvedOne;

  /// No description provided for @conflictArrived.
  ///
  /// In en, this message translates to:
  /// **'{medication} was recorded more than once'**
  String conflictArrived(String medication);

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @warningOffline.
  ///
  /// In en, this message translates to:
  /// **'This phone is offline: someone may have given it already.'**
  String get warningOffline;

  /// No description provided for @doseRecordedOffline.
  ///
  /// In en, this message translates to:
  /// **'{medication} saved on this phone. It will sync when the connection is back.'**
  String doseRecordedOffline(String medication);

  /// No description provided for @recordedByToday.
  ///
  /// In en, this message translates to:
  /// **'{name}, today at {time}'**
  String recordedByToday(String name, String time);

  /// No description provided for @givenWhen.
  ///
  /// In en, this message translates to:
  /// **'When was it given?'**
  String get givenWhen;

  /// No description provided for @givenNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get givenNow;

  /// No description provided for @givenMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String givenMinutesAgo(int minutes);

  /// No description provided for @givenHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour ago} other{{hours} hours ago}}'**
  String givenHoursAgo(int hours);

  /// No description provided for @givenPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get givenPickTime;

  /// No description provided for @givenAtTime.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String givenAtTime(String time);

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get navMedications;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String durationHours(int hours);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @nextIn.
  ///
  /// In en, this message translates to:
  /// **'Next dose · in {duration}'**
  String nextIn(String duration);

  /// No description provided for @nextDueNow.
  ///
  /// In en, this message translates to:
  /// **'Next dose · due now'**
  String get nextDueNow;

  /// No description provided for @nextLate.
  ///
  /// In en, this message translates to:
  /// **'Late by {duration}'**
  String nextLate(String duration);

  /// No description provided for @nextFromYesterday.
  ///
  /// In en, this message translates to:
  /// **'From yesterday · late'**
  String get nextFromYesterday;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @medicationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active medication} other{{count} active medications}}'**
  String medicationsCount(int count);

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @minIntervalText.
  ///
  /// In en, this message translates to:
  /// **'at least {duration} apart'**
  String minIntervalText(String duration);

  /// No description provided for @maxPerDayText.
  ///
  /// In en, this message translates to:
  /// **'up to {count} a day'**
  String maxPerDayText(int count);

  /// No description provided for @stockNotCounted.
  ///
  /// In en, this message translates to:
  /// **'Stock not counted'**
  String get stockNotCounted;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet'**
  String get activityEmpty;

  /// No description provided for @activityCreated.
  ///
  /// In en, this message translates to:
  /// **'{name} added {medication}'**
  String activityCreated(String name, String medication);

  /// No description provided for @activityUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} edited {medication}'**
  String activityUpdated(String name, String medication);

  /// No description provided for @activityScheduleChanged.
  ///
  /// In en, this message translates to:
  /// **'{name} changed the schedule of {medication}'**
  String activityScheduleChanged(String name, String medication);

  /// No description provided for @activityArchived.
  ///
  /// In en, this message translates to:
  /// **'{name} archived {medication}'**
  String activityArchived(String name, String medication);

  /// No description provided for @activityGiven.
  ///
  /// In en, this message translates to:
  /// **'{name} gave {medication}'**
  String activityGiven(String name, String medication);

  /// No description provided for @activityGivenSlot.
  ///
  /// In en, this message translates to:
  /// **'{name} gave the {time} {medication}'**
  String activityGivenSlot(String name, String medication, String time);

  /// No description provided for @activitySkipped.
  ///
  /// In en, this message translates to:
  /// **'{name} skipped the {time} {medication}: {reason}'**
  String activitySkipped(
    String name,
    String medication,
    String time,
    String reason,
  );

  /// No description provided for @activityUndone.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled a record of {medication}'**
  String activityUndone(String name, String medication);

  /// No description provided for @activityCounted.
  ///
  /// In en, this message translates to:
  /// **'{name} counted {medication}: {units}'**
  String activityCounted(String name, String medication, String units);

  /// No description provided for @activityRefilled.
  ///
  /// In en, this message translates to:
  /// **'{name} added {units} of {medication}'**
  String activityRefilled(String name, String medication, String units);

  /// No description provided for @activityReviewed.
  ///
  /// In en, this message translates to:
  /// **'{name} reviewed a dose recorded twice'**
  String activityReviewed(String name);

  /// No description provided for @unknownMedication.
  ///
  /// In en, this message translates to:
  /// **'a medication'**
  String get unknownMedication;

  /// No description provided for @givenAtLabel.
  ///
  /// In en, this message translates to:
  /// **'given at {time}'**
  String givenAtLabel(String time);

  /// No description provided for @caringFor.
  ///
  /// In en, this message translates to:
  /// **'Caring for'**
  String get caringFor;

  /// No description provided for @stockUnitsCount.
  ///
  /// In en, this message translates to:
  /// **'{units} units'**
  String stockUnitsCount(String units);

  /// No description provided for @stockLasts.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Lasts 1 day} other{Lasts {days} days}}'**
  String stockLasts(int days);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @newMedication.
  ///
  /// In en, this message translates to:
  /// **'New medication'**
  String get newMedication;

  /// No description provided for @editMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit medication'**
  String get editMedication;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get fieldStrength;

  /// No description provided for @fieldStrengthHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500 mg'**
  String get fieldStrengthHint;

  /// No description provided for @fieldForm.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get fieldForm;

  /// No description provided for @fieldInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions (optional)'**
  String get fieldInstructions;

  /// No description provided for @fieldInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. With meals'**
  String get fieldInstructionsHint;

  /// No description provided for @fieldUnitsPerDose.
  ///
  /// In en, this message translates to:
  /// **'Units per dose'**
  String get fieldUnitsPerDose;

  /// No description provided for @fieldLowStockDays.
  ///
  /// In en, this message translates to:
  /// **'Warn when stock lasts'**
  String get fieldLowStockDays;

  /// No description provided for @daysValue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String daysValue(int days);

  /// No description provided for @fieldInitialStock.
  ///
  /// In en, this message translates to:
  /// **'Units in stock (optional)'**
  String get fieldInitialStock;

  /// No description provided for @prescriptionNote.
  ///
  /// In en, this message translates to:
  /// **'Enter the details as they appear on the prescription. ICare does not suggest doses.'**
  String get prescriptionNote;

  /// No description provided for @formTablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get formTablet;

  /// No description provided for @formCapsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get formCapsule;

  /// No description provided for @formLiquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid'**
  String get formLiquid;

  /// No description provided for @formDrops.
  ///
  /// In en, this message translates to:
  /// **'Drops'**
  String get formDrops;

  /// No description provided for @formInjection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get formInjection;

  /// No description provided for @formPatch.
  ///
  /// In en, this message translates to:
  /// **'Patch'**
  String get formPatch;

  /// No description provided for @formInhaler.
  ///
  /// In en, this message translates to:
  /// **'Inhaler'**
  String get formInhaler;

  /// No description provided for @formOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get formOther;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleFixed.
  ///
  /// In en, this message translates to:
  /// **'At set times'**
  String get scheduleFixed;

  /// No description provided for @scheduleAsNeeded.
  ///
  /// In en, this message translates to:
  /// **'As needed'**
  String get scheduleAsNeeded;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @removeTime.
  ///
  /// In en, this message translates to:
  /// **'Remove {time}'**
  String removeTime(String time);

  /// No description provided for @whichDays.
  ///
  /// In en, this message translates to:
  /// **'Which days'**
  String get whichDays;

  /// No description provided for @minIntervalOptional.
  ///
  /// In en, this message translates to:
  /// **'Minimum time between doses (optional)'**
  String get minIntervalOptional;

  /// No description provided for @minIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum time between doses'**
  String get minIntervalLabel;

  /// No description provided for @maxPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum per day (optional)'**
  String get maxPerDayLabel;

  /// No description provided for @hoursValue.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour} other{{hours} hours}}'**
  String hoursValue(int hours);

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @issueNameMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter the name'**
  String get issueNameMissing;

  /// No description provided for @issueUnitsPerDose.
  ///
  /// In en, this message translates to:
  /// **'Units per dose must be more than 0'**
  String get issueUnitsPerDose;

  /// No description provided for @issueNoTimes.
  ///
  /// In en, this message translates to:
  /// **'Add at least one time'**
  String get issueNoTimes;

  /// No description provided for @issueMinInterval.
  ///
  /// In en, this message translates to:
  /// **'The time between doses must be more than 0'**
  String get issueMinInterval;

  /// No description provided for @issueMaxPerDay.
  ///
  /// In en, this message translates to:
  /// **'The maximum per day must be at least 1'**
  String get issueMaxPerDay;

  /// No description provided for @issueStockNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get issueStockNumber;

  /// No description provided for @changeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Change schedule'**
  String get changeSchedule;

  /// No description provided for @scheduleFromWhen.
  ///
  /// In en, this message translates to:
  /// **'From when?'**
  String get scheduleFromWhen;

  /// No description provided for @fromNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get fromNow;

  /// No description provided for @fromTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get fromTomorrow;

  /// No description provided for @fromPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get fromPickDate;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String fromDate(String date);

  /// No description provided for @earlierDosesUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Earlier doses keep the schedule they had.'**
  String get earlierDosesUnchanged;

  /// No description provided for @previousSchedules.
  ///
  /// In en, this message translates to:
  /// **'Earlier schedules'**
  String get previousSchedules;

  /// No description provided for @scheduleUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String scheduleUntil(String date);

  /// No description provided for @stockTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockTitle;

  /// No description provided for @recount.
  ///
  /// In en, this message translates to:
  /// **'Recount'**
  String get recount;

  /// No description provided for @boughtMore.
  ///
  /// In en, this message translates to:
  /// **'Bought more'**
  String get boughtMore;

  /// No description provided for @howManyLeft.
  ///
  /// In en, this message translates to:
  /// **'How many are left?'**
  String get howManyLeft;

  /// No description provided for @howManyBought.
  ///
  /// In en, this message translates to:
  /// **'How many did you buy?'**
  String get howManyBought;

  /// No description provided for @recentDoses.
  ///
  /// In en, this message translates to:
  /// **'Recent doses'**
  String get recentDoses;

  /// No description provided for @instructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructionsTitle;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @archiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive {medication}?'**
  String archiveTitle(String medication);

  /// No description provided for @archiveBody.
  ///
  /// In en, this message translates to:
  /// **'It will no longer appear in Today or in the list. Its history stays in Activity.'**
  String get archiveBody;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @medicationSaved.
  ///
  /// In en, this message translates to:
  /// **'{medication} saved'**
  String medicationSaved(String medication);

  /// No description provided for @medicationSavedFirstDose.
  ///
  /// In en, this message translates to:
  /// **'{medication} saved · First dose: {when}'**
  String medicationSavedFirstDose(String medication, String when);

  /// No description provided for @nextDoseLater.
  ///
  /// In en, this message translates to:
  /// **'Next dose: {medication}, {when}'**
  String nextDoseLater(String medication, String when);

  /// No description provided for @editConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Changed by more than one person at the same time'**
  String get editConflictTitle;

  /// No description provided for @editConflictBody.
  ///
  /// In en, this message translates to:
  /// **'The last change received is the one in use. Choose which one to keep.'**
  String get editConflictBody;

  /// No description provided for @keepThis.
  ///
  /// In en, this message translates to:
  /// **'Keep this one'**
  String get keepThis;

  /// No description provided for @useThis.
  ///
  /// In en, this message translates to:
  /// **'Use this one'**
  String get useThis;

  /// No description provided for @inUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get inUse;

  /// No description provided for @changeBy.
  ///
  /// In en, this message translates to:
  /// **'{name} at {time}'**
  String changeBy(String name, String time);

  /// No description provided for @changeArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived it'**
  String get changeArchived;

  /// No description provided for @medicationConflictBadge.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get medicationConflictBadge;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @issueNoWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one day'**
  String get issueNoWeekdays;

  /// No description provided for @pickDays.
  ///
  /// In en, this message translates to:
  /// **'Choose days'**
  String get pickDays;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @sectionMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get sectionMedication;

  /// No description provided for @sectionDoseAndStock.
  ///
  /// In en, this message translates to:
  /// **'Dose and stock'**
  String get sectionDoseAndStock;

  /// No description provided for @sectionFromWhen.
  ///
  /// In en, this message translates to:
  /// **'From when'**
  String get sectionFromWhen;

  /// No description provided for @unknownAppointment.
  ///
  /// In en, this message translates to:
  /// **'an appointment'**
  String get unknownAppointment;

  /// No description provided for @activityAppointmentCreated.
  ///
  /// In en, this message translates to:
  /// **'{name} added the {title} appointment'**
  String activityAppointmentCreated(String name, String title);

  /// No description provided for @activityAppointmentUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} edited the {title} appointment'**
  String activityAppointmentUpdated(String name, String title);

  /// No description provided for @activityAppointmentCancelled.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled the {title} appointment'**
  String activityAppointmentCancelled(String name, String title);

  /// No description provided for @activityVisitNote.
  ///
  /// In en, this message translates to:
  /// **'{name} added a note to the {title} appointment'**
  String activityVisitNote(String name, String title);

  /// No description provided for @navAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get navAppointments;

  /// No description provided for @upcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingTitle;

  /// No description provided for @pastTitle.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get pastTitle;

  /// No description provided for @appointmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get appointmentsEmpty;

  /// No description provided for @noNotesPrompt.
  ///
  /// In en, this message translates to:
  /// **'No notes yet: add what the doctor said'**
  String get noNotesPrompt;

  /// No description provided for @questionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question to ask} other{{count} questions to ask}}'**
  String questionsCount(int count);

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 note} other{{count} notes}}'**
  String notesCount(int count);

  /// No description provided for @newAppointment.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get newAppointment;

  /// No description provided for @editAppointment.
  ///
  /// In en, this message translates to:
  /// **'Edit appointment'**
  String get editAppointment;

  /// No description provided for @sectionAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get sectionAppointment;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Specialty or reason'**
  String get fieldTitle;

  /// No description provided for @fieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cardiology'**
  String get fieldTitleHint;

  /// No description provided for @fieldDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor (optional)'**
  String get fieldDoctor;

  /// No description provided for @fieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Place (optional)'**
  String get fieldLocation;

  /// No description provided for @fieldDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get fieldDay;

  /// No description provided for @fieldTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fieldTime;

  /// No description provided for @sectionQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions for the doctor'**
  String get sectionQuestions;

  /// No description provided for @fieldQuestionsHint.
  ///
  /// In en, this message translates to:
  /// **'Write a question'**
  String get fieldQuestionsHint;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get addQuestion;

  /// No description provided for @removeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get removeQuestion;

  /// No description provided for @issueTitleMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter the specialty or reason'**
  String get issueTitleMissing;

  /// No description provided for @visitNotes.
  ///
  /// In en, this message translates to:
  /// **'Visit notes'**
  String get visitNotes;

  /// No description provided for @addNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What did the doctor say?'**
  String get addNoteHint;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get cancelAppointment;

  /// No description provided for @cancelAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel the {title} appointment?'**
  String cancelAppointmentTitle(String title);

  /// No description provided for @cancelAppointmentBody.
  ///
  /// In en, this message translates to:
  /// **'It will no longer appear in the list. Its notes stay in Activity.'**
  String get cancelAppointmentBody;

  /// No description provided for @keepAppointment.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepAppointment;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String todayAt(String time);

  /// No description provided for @tomorrowAt.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow, {time}'**
  String tomorrowAt(String time);

  /// No description provided for @dayAt.
  ///
  /// In en, this message translates to:
  /// **'{day}, {time}'**
  String dayAt(String day, String time);

  /// No description provided for @changeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled it'**
  String get changeCancelled;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get newNote;

  /// No description provided for @activityProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} updated the emergency card'**
  String activityProfileUpdated(String name);

  /// No description provided for @emergencyCard.
  ///
  /// In en, this message translates to:
  /// **'Emergency card'**
  String get emergencyCard;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years old'**
  String ageYears(int years);

  /// No description provided for @allergiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergiesTitle;

  /// No description provided for @noAllergies.
  ///
  /// In en, this message translates to:
  /// **'No known allergies'**
  String get noAllergies;

  /// No description provided for @conditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get conditionsTitle;

  /// No description provided for @medicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medicationsTitle;

  /// No description provided for @doctorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctorsTitle;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get contactsTitle;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @copyAsText.
  ///
  /// In en, this message translates to:
  /// **'Copy as text'**
  String get copyAsText;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied. Paste it in a message or show it at the hospital.'**
  String get copied;

  /// No description provided for @callName.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callName(String name);

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the phone app'**
  String get callFailed;

  /// No description provided for @emptyProfile.
  ///
  /// In en, this message translates to:
  /// **'Nobody has filled in the emergency card yet.'**
  String get emptyProfile;

  /// No description provided for @fillIn.
  ///
  /// In en, this message translates to:
  /// **'Fill it in'**
  String get fillIn;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit emergency card'**
  String get editProfile;

  /// No description provided for @sectionPerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get sectionPerson;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldFullName;

  /// No description provided for @fieldBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of birth (optional)'**
  String get fieldBirthDate;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @fieldAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies (one per line)'**
  String get fieldAllergies;

  /// No description provided for @fieldConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions (one per line)'**
  String get fieldConditions;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get fieldNotes;

  /// No description provided for @addDoctor.
  ///
  /// In en, this message translates to:
  /// **'Add doctor'**
  String get addDoctor;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// No description provided for @fieldPersonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldPersonName;

  /// No description provided for @fieldSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get fieldSpecialty;

  /// No description provided for @fieldRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get fieldRelationship;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fieldPhone;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @handoffTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes for the circle'**
  String get handoffTitle;

  /// No description provided for @handoffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For whoever takes over. Everyone in the circle sees them.'**
  String get handoffSubtitle;

  /// No description provided for @handoffHeader.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s day · {day}, {time}'**
  String handoffHeader(String name, String day, String time);

  /// No description provided for @handoffGiven.
  ///
  /// In en, this message translates to:
  /// **'Given today:'**
  String get handoffGiven;

  /// No description provided for @handoffSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped today:'**
  String get handoffSkipped;

  /// No description provided for @handoffPending.
  ///
  /// In en, this message translates to:
  /// **'Still to give:'**
  String get handoffPending;

  /// No description provided for @handoffNothingPending.
  ///
  /// In en, this message translates to:
  /// **'Nothing left to give today.'**
  String get handoffNothingPending;

  /// No description provided for @handoffConflicts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dose recorded twice: check it in ICare.} other{{count} doses recorded twice: check them in ICare.}}'**
  String handoffConflicts(int count);

  /// No description provided for @handoffLowStock.
  ///
  /// In en, this message translates to:
  /// **'Running low:'**
  String get handoffLowStock;

  /// No description provided for @handoffNextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next appointment:'**
  String get handoffNextAppointment;

  /// No description provided for @handoffLastNote.
  ///
  /// In en, this message translates to:
  /// **'Last visit note ({title}, {name}):'**
  String handoffLastNote(String title, String name);

  /// No description provided for @handoffCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied. Paste it in your family chat.'**
  String get handoffCopied;

  /// No description provided for @handoffNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get handoffNotes;

  /// No description provided for @noteFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Write something for whoever\'s next'**
  String get noteFieldHint;

  /// No description provided for @leaveNote.
  ///
  /// In en, this message translates to:
  /// **'Leave note'**
  String get leaveNote;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. What you write here, everyone in the circle sees.'**
  String get notesEmpty;

  /// No description provided for @copySummary.
  ///
  /// In en, this message translates to:
  /// **'Copy the day\'s summary'**
  String get copySummary;

  /// No description provided for @activityCareNote.
  ///
  /// In en, this message translates to:
  /// **'{name} left a note: {text}'**
  String activityCareNote(String name, String text);

  /// No description provided for @yesterdayAt.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {time}'**
  String yesterdayAt(String time);

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @sectionDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get sectionDemo;

  /// No description provided for @resetDemo.
  ///
  /// In en, this message translates to:
  /// **'Reset sample data'**
  String get resetDemo;

  /// No description provided for @resetDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Deletes everything recorded on both phones and loads the sample data again.'**
  String get resetDemoBody;

  /// No description provided for @resetDemoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetDemoConfirm;

  /// No description provided for @resetDone.
  ///
  /// In en, this message translates to:
  /// **'Sample data loaded again'**
  String get resetDone;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenses;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ICare'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Keep track of {name}\'s care together: who gave each dose and when, stock, appointments and notes.'**
  String welcomeBody(String name);

  /// No description provided for @welcomeSample.
  ///
  /// In en, this message translates to:
  /// **'Everything here is sample data. Try it freely.'**
  String get welcomeSample;

  /// No description provided for @welcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get welcomeStart;

  /// No description provided for @unknownTask.
  ///
  /// In en, this message translates to:
  /// **'a task'**
  String get unknownTask;

  /// No description provided for @activityTaskCreated.
  ///
  /// In en, this message translates to:
  /// **'{name} added the task {task}'**
  String activityTaskCreated(String name, String task);

  /// No description provided for @activityTaskUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} changed the task {task}'**
  String activityTaskUpdated(String name, String task);

  /// No description provided for @activityTaskArchived.
  ///
  /// In en, this message translates to:
  /// **'{name} archived the task {task}'**
  String activityTaskArchived(String name, String task);

  /// No description provided for @activityTaskDone.
  ///
  /// In en, this message translates to:
  /// **'{name} did: {task}'**
  String activityTaskDone(String name, String task);

  /// No description provided for @activityTaskSkipped.
  ///
  /// In en, this message translates to:
  /// **'{name} skipped {task}: {reason}'**
  String activityTaskSkipped(String name, String task, String reason);

  /// No description provided for @statusToDoToday.
  ///
  /// In en, this message translates to:
  /// **'To do today'**
  String get statusToDoToday;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @duringTheDay.
  ///
  /// In en, this message translates to:
  /// **'During the day'**
  String get duringTheDay;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get markDone;

  /// No description provided for @markNotDone.
  ///
  /// In en, this message translates to:
  /// **'Not done'**
  String get markNotDone;

  /// No description provided for @taskSkipReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Why wasn\'t it done?'**
  String get taskSkipReasonTitle;

  /// No description provided for @taskRecordedDone.
  ///
  /// In en, this message translates to:
  /// **'{task}: done'**
  String taskRecordedDone(String task);

  /// No description provided for @taskRecordedSkipped.
  ///
  /// In en, this message translates to:
  /// **'{task}: not done'**
  String taskRecordedSkipped(String task);

  /// No description provided for @taskRecords.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get taskRecords;

  /// No description provided for @removeDoneBody.
  ///
  /// In en, this message translates to:
  /// **'{name} marked it as done at {time}. Remove it only if it wasn\'t done. The change shows in Activity.'**
  String removeDoneBody(String name, String time);

  /// No description provided for @removeTaskSkippedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} marked it as not done. Remove it if it is still to do. The change shows in Activity.'**
  String removeTaskSkippedBody(String name);

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @tasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task} other{{count} tasks}}'**
  String tasksCount(int count);

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet. Add care that isn\'t a medication, like a bath, a walk or a skin check.'**
  String get tasksEmpty;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @sectionTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get sectionTask;

  /// No description provided for @fieldTaskNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bath'**
  String get fieldTaskNameHint;

  /// No description provided for @fieldTaskNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Use the shower chair'**
  String get fieldTaskNoteHint;

  /// No description provided for @sectionWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get sectionWhen;

  /// No description provided for @taskAtSetTimes.
  ///
  /// In en, this message translates to:
  /// **'At set times'**
  String get taskAtSetTimes;

  /// No description provided for @handoffTasksDone.
  ///
  /// In en, this message translates to:
  /// **'Tasks done today:'**
  String get handoffTasksDone;

  /// No description provided for @handoffTasksSkipped.
  ///
  /// In en, this message translates to:
  /// **'Tasks not done today:'**
  String get handoffTasksSkipped;

  /// No description provided for @handoffTasksPending.
  ///
  /// In en, this message translates to:
  /// **'Tasks still to do:'**
  String get handoffTasksPending;

  /// No description provided for @tabMedications.
  ///
  /// In en, this message translates to:
  /// **'Meds'**
  String get tabMedications;

  /// No description provided for @tabAppointments.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get tabAppointments;

  /// No description provided for @activityDocumentLinked.
  ///
  /// In en, this message translates to:
  /// **'{name} added {document} to the {title} appointment'**
  String activityDocumentLinked(String name, String document, String title);

  /// No description provided for @activityDocumentRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed a document from the {title} appointment'**
  String activityDocumentRemoved(String name, String title);

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Studies and documents'**
  String get documentsTitle;

  /// No description provided for @documentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Keep links to results, reports or orders here, so they are at hand at the visit.'**
  String get documentsEmpty;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLink;

  /// No description provided for @newLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'New link'**
  String get newLinkTitle;

  /// No description provided for @fieldDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'What it is'**
  String get fieldDocumentTitle;

  /// No description provided for @fieldDocumentTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blood test results'**
  String get fieldDocumentTitleHint;

  /// No description provided for @fieldDocumentUrl.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get fieldDocumentUrl;

  /// No description provided for @fieldDocumentUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the address'**
  String get fieldDocumentUrlHint;

  /// No description provided for @linkOnlyNote.
  ///
  /// In en, this message translates to:
  /// **'ICare keeps the link, not the file: it opens wherever the document already is, like the lab\'s website or a shared folder.'**
  String get linkOnlyNote;

  /// No description provided for @issueDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter what it is'**
  String get issueDocumentTitle;

  /// No description provided for @issueDocumentUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a web address, like lab.example.com/results'**
  String get issueDocumentUrl;

  /// No description provided for @removeDocument.
  ///
  /// In en, this message translates to:
  /// **'Remove {document}'**
  String removeDocument(String document);

  /// No description provided for @removeDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {document}?'**
  String removeDocumentTitle(String document);

  /// No description provided for @removeDocumentBody.
  ///
  /// In en, this message translates to:
  /// **'The link is taken off this appointment. The change shows in Activity.'**
  String get removeDocumentBody;

  /// No description provided for @linkAdded.
  ///
  /// In en, this message translates to:
  /// **'Link added'**
  String get linkAdded;

  /// No description provided for @openLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get openLinkFailed;

  /// No description provided for @documentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 document} other{{count} documents}}'**
  String documentsCount(int count);

  /// No description provided for @handoffDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents for it:'**
  String get handoffDocuments;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get roleCaregiver;

  /// No description provided for @roleHelper.
  ///
  /// In en, this message translates to:
  /// **'Helper'**
  String get roleHelper;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'View only'**
  String get roleViewer;

  /// No description provided for @activityMemberInvited.
  ///
  /// In en, this message translates to:
  /// **'{name} invited {member} ({role})'**
  String activityMemberInvited(String name, String member, String role);

  /// No description provided for @activityInvitationRevoked.
  ///
  /// In en, this message translates to:
  /// **'{name} withdrew {member}\'s invitation'**
  String activityInvitationRevoked(String name, String member);

  /// No description provided for @activityMemberJoined.
  ///
  /// In en, this message translates to:
  /// **'{member} joined the circle'**
  String activityMemberJoined(String member);

  /// No description provided for @activityRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'{name} changed {member}\'s role to {role}'**
  String activityRoleChanged(String name, String member, String role);

  /// No description provided for @activityMemberRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed {member} from the circle'**
  String activityMemberRemoved(String name, String member);

  /// No description provided for @activityMemberLeft.
  ///
  /// In en, this message translates to:
  /// **'{member} left the circle on a phone'**
  String activityMemberLeft(String member);

  /// No description provided for @circleTitle.
  ///
  /// In en, this message translates to:
  /// **'The circle'**
  String get circleTitle;

  /// No description provided for @thisPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get thisPhone;

  /// No description provided for @memberInvitedStatus.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get memberInvitedStatus;

  /// No description provided for @syncRejected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record not sent} other{{count} records not sent}}'**
  String syncRejected(int count);

  /// No description provided for @sectionNotSent.
  ///
  /// In en, this message translates to:
  /// **'Not sent'**
  String get sectionNotSent;

  /// No description provided for @notSentNote.
  ///
  /// In en, this message translates to:
  /// **'The server refused these records, so nobody else has them and the app shows them nowhere else.'**
  String get notSentNote;

  /// No description provided for @rejectedWrongAuthor.
  ///
  /// In en, this message translates to:
  /// **'It was written as someone else.'**
  String get rejectedWrongAuthor;

  /// No description provided for @rejectedNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Your role does not allow it.'**
  String get rejectedNotAllowed;

  /// No description provided for @rejectedNotMember.
  ///
  /// In en, this message translates to:
  /// **'You are no longer in the circle.'**
  String get rejectedNotMember;

  /// No description provided for @rejectedLastAdmin.
  ///
  /// In en, this message translates to:
  /// **'The circle would be left without an admin.'**
  String get rejectedLastAdmin;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @afterAccessEnded.
  ///
  /// In en, this message translates to:
  /// **'After their access ended'**
  String get afterAccessEnded;

  /// No description provided for @errorNotMember.
  ///
  /// In en, this message translates to:
  /// **'This phone is not in the circle any more.'**
  String get errorNotMember;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Your role does not allow it.'**
  String get errorForbidden;

  /// No description provided for @errorCodeUnknown.
  ///
  /// In en, this message translates to:
  /// **'That code does not exist. Check it with whoever sent it.'**
  String get errorCodeUnknown;

  /// No description provided for @errorCodeUsed.
  ///
  /// In en, this message translates to:
  /// **'That code was already used. Ask for a new one.'**
  String get errorCodeUsed;

  /// No description provided for @errorCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'That code expired. Ask for a new one.'**
  String get errorCodeExpired;

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a care circle'**
  String get joinTitle;

  /// No description provided for @joinBody.
  ///
  /// In en, this message translates to:
  /// **'Ask an admin of the circle for a code. It works once, for 48 hours.'**
  String get joinBody;

  /// No description provided for @fieldCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get fieldCode;

  /// No description provided for @fieldCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. K7P-4QM'**
  String get fieldCodeHint;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @joinDemoHint.
  ///
  /// In en, this message translates to:
  /// **'In this demo, an admin makes codes on the other phone: Settings, The circle, tap someone, New code.'**
  String get joinDemoHint;

  /// No description provided for @removedTitle.
  ///
  /// In en, this message translates to:
  /// **'This phone is out of the circle'**
  String get removedTitle;

  /// No description provided for @removedBody.
  ///
  /// In en, this message translates to:
  /// **'An admin took you out of the circle. Anything this phone had not sent was sent first; what it kept is cleared now.'**
  String get removedBody;

  /// No description provided for @removedOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get removedOk;

  /// No description provided for @inviteSomeone.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get inviteSomeone;

  /// No description provided for @inviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite to the circle'**
  String get inviteTitle;

  /// No description provided for @fieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get fieldRole;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @roleAdminAbout.
  ///
  /// In en, this message translates to:
  /// **'Everything, including who belongs.'**
  String get roleAdminAbout;

  /// No description provided for @roleCaregiverAbout.
  ///
  /// In en, this message translates to:
  /// **'Daily care: medications, tasks and visits.'**
  String get roleCaregiverAbout;

  /// No description provided for @roleHelperAbout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s doses and tasks only.'**
  String get roleHelperAbout;

  /// No description provided for @roleViewerAbout.
  ///
  /// In en, this message translates to:
  /// **'Sees everything, changes nothing.'**
  String get roleViewerAbout;

  /// No description provided for @codeTitle.
  ///
  /// In en, this message translates to:
  /// **'Code for {name}'**
  String codeTitle(String name);

  /// No description provided for @codeValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Works once, until {when}.'**
  String codeValidUntil(String when);

  /// No description provided for @codeShareHint.
  ///
  /// In en, this message translates to:
  /// **'Send it however you like. On the new phone, enter it to join.'**
  String get codeShareHint;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @newCode.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get newCode;

  /// No description provided for @newCodeAbout.
  ///
  /// In en, this message translates to:
  /// **'For another device, or if the last code was lost. The previous one stops working.'**
  String get newCodeAbout;

  /// No description provided for @withdrawInvitation.
  ///
  /// In en, this message translates to:
  /// **'Withdraw invitation'**
  String get withdrawInvitation;

  /// No description provided for @withdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw {name}\'s invitation?'**
  String withdrawTitle(String name);

  /// No description provided for @withdrawBody.
  ///
  /// In en, this message translates to:
  /// **'Their code stops working.'**
  String get withdrawBody;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove from the circle'**
  String get removeMember;

  /// No description provided for @removeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the circle?'**
  String removeMemberTitle(String name);

  /// No description provided for @removeMemberBody.
  ///
  /// In en, this message translates to:
  /// **'Their phones stop syncing and clear what they kept. Their records stay in Activity.'**
  String get removeMemberBody;

  /// No description provided for @lastAdminNote.
  ///
  /// In en, this message translates to:
  /// **'The circle needs at least one admin.'**
  String get lastAdminNote;

  /// No description provided for @leaveCircle.
  ///
  /// In en, this message translates to:
  /// **'Leave the circle on this phone'**
  String get leaveCircle;

  /// No description provided for @leaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the circle on this phone?'**
  String get leaveTitle;

  /// No description provided for @leaveBody.
  ///
  /// In en, this message translates to:
  /// **'Anything not sent yet is sent first, then this phone\'s copy is cleared. Coming back takes a new code.'**
  String get leaveBody;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @leaveOffline.
  ///
  /// In en, this message translates to:
  /// **'Connect to leave: there are records still to send.'**
  String get leaveOffline;

  /// No description provided for @conflictNeedsReviewer.
  ///
  /// In en, this message translates to:
  /// **'An admin or a caregiver will review it.'**
  String get conflictNeedsReviewer;

  /// No description provided for @daySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today so far'**
  String get daySummaryTitle;

  /// No description provided for @summaryNothingLate.
  ///
  /// In en, this message translates to:
  /// **'Nothing late'**
  String get summaryNothingLate;

  /// No description provided for @summaryLate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 late} other{{count} late}}'**
  String summaryLate(int count);

  /// No description provided for @summaryTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks: {done} of {total}'**
  String summaryTasks(int done, int total);

  /// No description provided for @summaryLast.
  ///
  /// In en, this message translates to:
  /// **'Last: {record}, at {time}.'**
  String summaryLast(String record, String time);

  /// No description provided for @summaryNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded today yet.'**
  String get summaryNothingYet;

  /// No description provided for @activityReasonAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added the reason \"{reason}\"'**
  String activityReasonAdded(String name, String reason);

  /// No description provided for @activityReasonHidden.
  ///
  /// In en, this message translates to:
  /// **'{name} stopped offering \"{reason}\"'**
  String activityReasonHidden(String name, String reason);

  /// No description provided for @activityReasonShown.
  ///
  /// In en, this message translates to:
  /// **'{name} offered \"{reason}\" again'**
  String activityReasonShown(String name, String reason);

  /// No description provided for @skipOtherField.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get skipOtherField;

  /// No description provided for @skipOtherSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get skipOtherSave;

  /// No description provided for @sectionReasons.
  ///
  /// In en, this message translates to:
  /// **'Reasons for not giving or doing'**
  String get sectionReasons;

  /// No description provided for @reasonsNote.
  ///
  /// In en, this message translates to:
  /// **'Offered when a dose is not given or a task not done. \"Other\" is always there, to write what happened.'**
  String get reasonsNote;

  /// No description provided for @reasonMedicationsOnly.
  ///
  /// In en, this message translates to:
  /// **'Medications only'**
  String get reasonMedicationsOnly;

  /// No description provided for @reasonOwn.
  ///
  /// In en, this message translates to:
  /// **'Added by the circle'**
  String get reasonOwn;

  /// No description provided for @fieldNewReason.
  ///
  /// In en, this message translates to:
  /// **'New reason'**
  String get fieldNewReason;

  /// No description provided for @fieldNewReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. At the hospital'**
  String get fieldNewReasonHint;

  /// No description provided for @addReason.
  ///
  /// In en, this message translates to:
  /// **'Add reason'**
  String get addReason;

  /// No description provided for @editReasons.
  ///
  /// In en, this message translates to:
  /// **'Edit reasons'**
  String get editReasons;

  /// No description provided for @reasonExists.
  ///
  /// In en, this message translates to:
  /// **'Enter a reason that is not on the list.'**
  String get reasonExists;

  /// No description provided for @activityCircleCreated.
  ///
  /// In en, this message translates to:
  /// **'The circle for {recipient} began'**
  String activityCircleCreated(String recipient);

  /// No description provided for @theRecipient.
  ///
  /// In en, this message translates to:
  /// **'the person you care for'**
  String get theRecipient;

  /// No description provided for @createCircle.
  ///
  /// In en, this message translates to:
  /// **'Create a circle'**
  String get createCircle;

  /// No description provided for @createCircleLead.
  ///
  /// In en, this message translates to:
  /// **'Starting a new circle?'**
  String get createCircleLead;

  /// No description provided for @createCircleBody.
  ///
  /// In en, this message translates to:
  /// **'You will be its admin, and invite the others from Settings.'**
  String get createCircleBody;

  /// No description provided for @fieldYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fieldYourName;

  /// No description provided for @fieldRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Who do you care for?'**
  String get fieldRecipientName;

  /// No description provided for @fieldRecipientHint.
  ///
  /// In en, this message translates to:
  /// **'Their first name, e.g. Elena'**
  String get fieldRecipientHint;

  /// No description provided for @circleExists.
  ///
  /// In en, this message translates to:
  /// **'This demo already has a circle. Join it with a code from its admin.'**
  String get circleExists;

  /// No description provided for @exploreSample.
  ///
  /// In en, this message translates to:
  /// **'Explore with sample data'**
  String get exploreSample;

  /// No description provided for @startFromScratch.
  ///
  /// In en, this message translates to:
  /// **'Start from scratch'**
  String get startFromScratch;

  /// No description provided for @startEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start from scratch?'**
  String get startEmptyTitle;

  /// No description provided for @startEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Both phones and the server are cleared. You create your own circle and add everything yourself.'**
  String get startEmptyBody;

  /// No description provided for @welcomeDemoChoice.
  ///
  /// In en, this message translates to:
  /// **'Only in this demo: try it with sample data, or empty, to add everything yourself.'**
  String get welcomeDemoChoice;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone {number}'**
  String phoneNumber(int number);

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing to review} other{{count} things to review}}'**
  String toReview(int count);

  /// No description provided for @notesRowEmpty.
  ///
  /// In en, this message translates to:
  /// **'Leave a note for whoever\'s next'**
  String get notesRowEmpty;

  /// No description provided for @notesRowNone.
  ///
  /// In en, this message translates to:
  /// **'No notes this week'**
  String get notesRowNone;

  /// No description provided for @notePreview.
  ///
  /// In en, this message translates to:
  /// **'{name}: {text}'**
  String notePreview(String name, String text);

  /// No description provided for @doneOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String doneOfTotal(int done, int total);

  /// No description provided for @resolvedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 done} other{{count} done}}'**
  String resolvedCount(int count);

  /// No description provided for @nothingToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled for today.'**
  String get nothingToday;
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
