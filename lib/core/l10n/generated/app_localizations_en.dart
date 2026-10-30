// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ICare';

  @override
  String get retry => 'Try again';

  @override
  String get todayTitle => 'Today';

  @override
  String get medicalDisclaimer =>
      'ICare helps caregivers keep track together. It does not give medical advice: follow the instructions of the treating doctor or pharmacist.';

  @override
  String get errorLoadData => 'We couldn\'t read the saved data.';

  @override
  String get errorNotFound => 'We couldn\'t find that item.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorOffline =>
      'You\'re offline. Changes are saved on this device and sync when the connection is back.';

  @override
  String get errorTimeout => 'This is taking too long. Please try again.';

  @override
  String get errorServer =>
      'The sync service is having trouble. Try again soon.';

  @override
  String get sampleData => 'Sample data';

  @override
  String syncedAt(String time) {
    return 'Synced at $time';
  }

  @override
  String get syncNever => 'Not synced yet';

  @override
  String get syncOffline => 'Offline';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes waiting to sync',
      one: '1 change waiting to sync',
    );
    return '$_temp0';
  }

  @override
  String get fromYesterday => 'From yesterday';

  @override
  String get dayPartMorning => 'Morning';

  @override
  String get dayPartMidday => 'Midday';

  @override
  String get dayPartAfternoon => 'Afternoon';

  @override
  String get dayPartNight => 'Night';

  @override
  String get asNeeded => 'As needed';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusDue => 'Due now';

  @override
  String get statusOverdue => 'Late';

  @override
  String get statusGiven => 'Given';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusGivenTwice => 'Given twice';

  @override
  String recordedBy(String name, String time) {
    return '$name at $time';
  }

  @override
  String lastDose(String time, String name) {
    return 'Last dose: $time, by $name';
  }

  @override
  String get noDoseYet => 'No doses recorded';

  @override
  String stockDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
      zero: 'Runs out today',
    );
    return '$_temp0';
  }

  @override
  String get stockOut => 'Out of stock';

  @override
  String get doubleDoseBody =>
      'Recorded as given more than once. If in doubt, ask the doctor or pharmacist.';

  @override
  String get markGiven => 'Mark as given';

  @override
  String get markGivenAnyway => 'Mark as given anyway';

  @override
  String get skipDose => 'Skip this dose';

  @override
  String get skipReasonTitle => 'Why is it skipped?';

  @override
  String get skipRefused => 'Refused it';

  @override
  String get skipAsleep => 'Was asleep';

  @override
  String get skipUnwell => 'Felt unwell';

  @override
  String get skipDoctorAdvice => 'Doctor\'s advice';

  @override
  String get skipOther => 'Other reason';

  @override
  String skippedBy(String name, String reason) {
    return 'Skipped by $name: $reason';
  }

  @override
  String doseRecordedGiven(String medication) {
    return '$medication recorded as given';
  }

  @override
  String doseRecordedSkipped(String medication) {
    return '$medication recorded as skipped';
  }

  @override
  String get undo => 'Undo';

  @override
  String get checkBeforeGiving => 'Check before giving it';

  @override
  String warningAlreadyGiven(String name, String time) {
    return '$name already recorded it at $time.';
  }

  @override
  String warningTooSoon(String last, String next) {
    return 'The last dose was at $last. With the interval you entered, the next one is from $next.';
  }

  @override
  String warningDailyLimit(int given, int max) {
    return '$given of $max doses given today, the maximum you entered.';
  }

  @override
  String warningOutOfDate(String time) {
    return 'This phone last synced at $time: someone may have given it already.';
  }

  @override
  String get warningNeverSynced =>
      'This phone has not synced yet: someone may have given it already.';

  @override
  String scheduledAt(String time) {
    return 'Scheduled at $time';
  }

  @override
  String get recordedToday => 'Recorded today';

  @override
  String get recordedForThisDose => 'Recorded for this dose';

  @override
  String get unknownCaregiver => 'Someone';

  @override
  String get whoAreYou => 'Who are you?';

  @override
  String phoneOf(String name) {
    return '$name\'s phone';
  }

  @override
  String get networkOn => 'Connected';

  @override
  String get networkOff => 'Offline';

  @override
  String get demoHint =>
      'Two phones synced through a simulated server. To simulate a dose recorded late: turn Martín\'s phone off, mark the same dose on both and turn it back on.';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get notSyncedYet => 'Not synced yet';

  @override
  String conflictSlotTitle(String medication, String time, int count) {
    return '$medication at $time was recorded $count times';
  }

  @override
  String conflictCloseTitle(String medication) {
    return '$medication: doses too close together';
  }

  @override
  String get conflictExplanation =>
      'They were recorded on different phones, without seeing each other\'s record.';

  @override
  String conflictQuestion(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Did $name get all $count doses?',
      two: 'Did $name get both doses?',
    );
    return '$_temp0';
  }

  @override
  String get conflictOnlyOne => 'No, only one';

  @override
  String conflictAllGiven(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yes, all were given',
      two: 'Yes, both were given',
    );
    return '$_temp0';
  }

  @override
  String get conflictNotSure => 'I don\'t know yet';

  @override
  String get conflictResolvedOne => 'Repeated record cancelled';

  @override
  String conflictArrived(String medication) {
    return '$medication was recorded more than once';
  }

  @override
  String get review => 'Review';

  @override
  String get warningOffline =>
      'This phone is offline: someone may have given it already.';

  @override
  String doseRecordedOffline(String medication) {
    return '$medication saved on this phone. It will sync when the connection is back.';
  }

  @override
  String recordedByToday(String name, String time) {
    return '$name, today at $time';
  }

  @override
  String get givenWhen => 'When was it given?';

  @override
  String get givenNow => 'Now';

  @override
  String givenMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String givenHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get givenPickTime => 'Pick a time';

  @override
  String givenAtTime(String time) {
    return 'At $time';
  }

  @override
  String get navToday => 'Today';

  @override
  String get navMedications => 'Medications';

  @override
  String get navActivity => 'Activity';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationHours(int hours) {
    return '$hours h';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String nextIn(String duration) {
    return 'Next dose · in $duration';
  }

  @override
  String get nextDueNow => 'Next dose · due now';

  @override
  String nextLate(String duration) {
    return 'Late by $duration';
  }

  @override
  String get nextFromYesterday => 'From yesterday · late';

  @override
  String get moreOptions => 'More options';

  @override
  String get dayDone => 'All of today\'s doses are recorded';

  @override
  String dayProgress(int done, int total) {
    return '$done of $total doses recorded today';
  }

  @override
  String medicationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active medications',
      one: '1 active medication',
    );
    return '$_temp0';
  }

  @override
  String get everyDay => 'Every day';

  @override
  String minIntervalText(String duration) {
    return 'at least $duration apart';
  }

  @override
  String maxPerDayText(int count) {
    return 'up to $count a day';
  }

  @override
  String get stockNotCounted => 'Stock not counted';

  @override
  String get today => 'Today';

  @override
  String get activityEmpty => 'Nothing recorded yet';

  @override
  String activityCreated(String name, String medication) {
    return '$name added $medication';
  }

  @override
  String activityUpdated(String name, String medication) {
    return '$name edited $medication';
  }

  @override
  String activityScheduleChanged(String name, String medication) {
    return '$name changed the schedule of $medication';
  }

  @override
  String activityArchived(String name, String medication) {
    return '$name archived $medication';
  }

  @override
  String activityGiven(String name, String medication) {
    return '$name gave $medication';
  }

  @override
  String activityGivenSlot(String name, String medication, String time) {
    return '$name gave the $time $medication';
  }

  @override
  String activitySkipped(
    String name,
    String medication,
    String time,
    String reason,
  ) {
    return '$name skipped the $time $medication: $reason';
  }

  @override
  String activityUndone(String name, String medication) {
    return '$name cancelled a record of $medication';
  }

  @override
  String activityCounted(String name, String medication, String units) {
    return '$name counted $medication: $units';
  }

  @override
  String activityRefilled(String name, String medication, String units) {
    return '$name added $units of $medication';
  }

  @override
  String activityReviewed(String name) {
    return '$name reviewed a dose recorded twice';
  }

  @override
  String get unknownMedication => 'a medication';

  @override
  String givenAtLabel(String time) {
    return 'given at $time';
  }

  @override
  String get caringFor => 'Caring for';

  @override
  String stockUnitsCount(String units) {
    return '$units units';
  }

  @override
  String stockLasts(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Lasts $days days',
      one: 'Lasts 1 day',
    );
    return '$_temp0';
  }

  @override
  String get add => 'Add';

  @override
  String get newMedication => 'New medication';

  @override
  String get editMedication => 'Edit medication';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldStrength => 'Strength';

  @override
  String get fieldStrengthHint => 'e.g. 500 mg';

  @override
  String get fieldForm => 'Form';

  @override
  String get fieldInstructions => 'Instructions (optional)';

  @override
  String get fieldInstructionsHint => 'e.g. With meals';

  @override
  String get fieldUnitsPerDose => 'Units per dose';

  @override
  String get fieldLowStockDays => 'Warn when stock lasts';

  @override
  String daysValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get fieldInitialStock => 'Units in stock (optional)';

  @override
  String get prescriptionNote =>
      'Enter the details as they appear on the prescription. ICare does not suggest doses.';

  @override
  String get formTablet => 'Tablet';

  @override
  String get formCapsule => 'Capsule';

  @override
  String get formLiquid => 'Liquid';

  @override
  String get formDrops => 'Drops';

  @override
  String get formInjection => 'Injection';

  @override
  String get formPatch => 'Patch';

  @override
  String get formInhaler => 'Inhaler';

  @override
  String get formOther => 'Other';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get scheduleFixed => 'At set times';

  @override
  String get scheduleAsNeeded => 'As needed';

  @override
  String get addTime => 'Add time';

  @override
  String removeTime(String time) {
    return 'Remove $time';
  }

  @override
  String get whichDays => 'Which days';

  @override
  String get minIntervalOptional => 'Minimum time between doses (optional)';

  @override
  String get minIntervalLabel => 'Minimum time between doses';

  @override
  String get maxPerDayLabel => 'Maximum per day (optional)';

  @override
  String hoursValue(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get noLimit => 'No limit';

  @override
  String get issueNameMissing => 'Enter the name';

  @override
  String get issueUnitsPerDose => 'Units per dose must be more than 0';

  @override
  String get issueNoTimes => 'Add at least one time';

  @override
  String get issueMinInterval => 'The time between doses must be more than 0';

  @override
  String get issueMaxPerDay => 'The maximum per day must be at least 1';

  @override
  String get issueStockNumber => 'Enter a number';

  @override
  String get changeSchedule => 'Change schedule';

  @override
  String get scheduleFromWhen => 'From when?';

  @override
  String get fromNow => 'Now';

  @override
  String get fromTomorrow => 'Tomorrow';

  @override
  String get fromPickDate => 'Pick a date';

  @override
  String fromDate(String date) {
    return 'From $date';
  }

  @override
  String get earlierDosesUnchanged =>
      'Earlier doses keep the schedule they had.';

  @override
  String get previousSchedules => 'Earlier schedules';

  @override
  String scheduleUntil(String date) {
    return 'Until $date';
  }

  @override
  String get stockTitle => 'Stock';

  @override
  String get recount => 'Recount';

  @override
  String get boughtMore => 'Bought more';

  @override
  String get howManyLeft => 'How many are left?';

  @override
  String get howManyBought => 'How many did you buy?';

  @override
  String get recentDoses => 'Recent doses';

  @override
  String get instructionsTitle => 'Instructions';

  @override
  String get archive => 'Archive';

  @override
  String archiveTitle(String medication) {
    return 'Archive $medication?';
  }

  @override
  String get archiveBody =>
      'It will no longer appear in Today or in the list. Its history stays in Activity.';

  @override
  String get archived => 'Archived';

  @override
  String medicationSaved(String medication) {
    return '$medication saved';
  }

  @override
  String get editConflictTitle =>
      'Changed by more than one person at the same time';

  @override
  String get editConflictBody =>
      'The last change received is the one in use. Choose which one to keep.';

  @override
  String get keepThis => 'Keep this one';

  @override
  String get useThis => 'Use this one';

  @override
  String get inUse => 'In use';

  @override
  String changeBy(String name, String time) {
    return '$name at $time';
  }

  @override
  String get changeArchived => 'Archived it';

  @override
  String get medicationConflictBadge => 'Needs review';

  @override
  String get more => 'More';

  @override
  String get back => 'Back';

  @override
  String get issueNoWeekdays => 'Choose at least one day';

  @override
  String get pickDays => 'Choose days';

  @override
  String get done => 'Done';

  @override
  String get sectionMedication => 'Medication';

  @override
  String get sectionDoseAndStock => 'Dose and stock';

  @override
  String get sectionFromWhen => 'From when';

  @override
  String get unknownAppointment => 'an appointment';

  @override
  String activityAppointmentCreated(String name, String title) {
    return '$name added the $title appointment';
  }

  @override
  String activityAppointmentUpdated(String name, String title) {
    return '$name edited the $title appointment';
  }

  @override
  String activityAppointmentCancelled(String name, String title) {
    return '$name cancelled the $title appointment';
  }

  @override
  String activityVisitNote(String name, String title) {
    return '$name added a note to the $title appointment';
  }

  @override
  String get navAppointments => 'Appointments';

  @override
  String get upcomingTitle => 'Upcoming';

  @override
  String get pastTitle => 'Past';

  @override
  String get appointmentsEmpty => 'No appointments yet';

  @override
  String get noNotesPrompt => 'No notes yet: add what the doctor said';

  @override
  String questionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions to ask',
      one: '1 question to ask',
    );
    return '$_temp0';
  }

  @override
  String notesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notes',
      one: '1 note',
    );
    return '$_temp0';
  }

  @override
  String get newAppointment => 'New appointment';

  @override
  String get editAppointment => 'Edit appointment';

  @override
  String get sectionAppointment => 'Appointment';

  @override
  String get fieldTitle => 'Specialty or reason';

  @override
  String get fieldTitleHint => 'e.g. Cardiology';

  @override
  String get fieldDoctor => 'Doctor (optional)';

  @override
  String get fieldLocation => 'Place (optional)';

  @override
  String get fieldWhen => 'Date and time';

  @override
  String get sectionQuestions => 'Questions for the doctor';

  @override
  String get fieldQuestionsHint => 'One per line';

  @override
  String get issueTitleMissing => 'Enter the specialty or reason';

  @override
  String get visitNotes => 'Visit notes';

  @override
  String get addNoteHint => 'What did the doctor say?';

  @override
  String get addNote => 'Add note';

  @override
  String get cancelAppointment => 'Cancel appointment';

  @override
  String cancelAppointmentTitle(String title) {
    return 'Cancel the $title appointment?';
  }

  @override
  String get cancelAppointmentBody =>
      'It will no longer appear in the list. Its notes stay in Activity.';

  @override
  String get keepAppointment => 'Keep it';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get nextAppointment => 'Next appointment';

  @override
  String todayAt(String time) {
    return 'Today, $time';
  }

  @override
  String tomorrowAt(String time) {
    return 'Tomorrow, $time';
  }

  @override
  String dayAt(String day, String time) {
    return '$day, $time';
  }

  @override
  String get changeCancelled => 'Cancelled it';

  @override
  String get newNote => 'New note';

  @override
  String activityProfileUpdated(String name) {
    return '$name updated the emergency card';
  }

  @override
  String get emergencyCard => 'Emergency card';

  @override
  String ageYears(int years) {
    return '$years years old';
  }

  @override
  String get allergiesTitle => 'Allergies';

  @override
  String get noAllergies => 'No known allergies';

  @override
  String get conditionsTitle => 'Conditions';

  @override
  String get medicationsTitle => 'Medications';

  @override
  String get doctorsTitle => 'Doctors';

  @override
  String get contactsTitle => 'Emergency contacts';

  @override
  String get notesTitle => 'Notes';

  @override
  String get copyAsText => 'Copy as text';

  @override
  String get copied =>
      'Copied. Paste it in a message or show it at the hospital.';

  @override
  String callName(String name) {
    return 'Call $name';
  }

  @override
  String get callFailed => 'Couldn\'t open the phone app';

  @override
  String get emptyProfile => 'Nobody has filled in the emergency card yet.';

  @override
  String get fillIn => 'Fill it in';

  @override
  String get editProfile => 'Edit emergency card';

  @override
  String get sectionPerson => 'Person';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldBirthDate => 'Date of birth (optional)';

  @override
  String get notSet => 'Not set';

  @override
  String get fieldAllergies => 'Allergies (one per line)';

  @override
  String get fieldConditions => 'Conditions (one per line)';

  @override
  String get fieldNotes => 'Notes (optional)';

  @override
  String get addDoctor => 'Add doctor';

  @override
  String get addContact => 'Add contact';

  @override
  String get fieldPersonName => 'Name';

  @override
  String get fieldSpecialty => 'Specialty';

  @override
  String get fieldRelationship => 'Relationship';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get remove => 'Remove';

  @override
  String get handoffTitle => 'Handoff';

  @override
  String get handoffSubtitle => 'A summary for whoever takes over';

  @override
  String handoffHeader(String name, String day, String time) {
    return 'Handoff for $name · $day, $time';
  }

  @override
  String get handoffGiven => 'Given today:';

  @override
  String get handoffSkipped => 'Skipped today:';

  @override
  String get handoffPending => 'Still to give:';

  @override
  String get handoffNothingPending => 'Nothing left to give today.';

  @override
  String handoffConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses recorded twice: check them in ICare.',
      one: '1 dose recorded twice: check it in ICare.',
    );
    return '$_temp0';
  }

  @override
  String get handoffLowStock => 'Running low:';

  @override
  String get handoffNextAppointment => 'Next appointment:';

  @override
  String handoffLastNote(String title, String name) {
    return 'Last visit note ($title, $name):';
  }

  @override
  String get handoffCopied => 'Copied. Paste it in your family chat.';

  @override
  String get copy => 'Copy';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionWho => 'Who you are';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get sectionDemo => 'Demo';

  @override
  String get resetDemo => 'Reset sample data';

  @override
  String get resetDemoBody =>
      'Deletes everything recorded on both phones and loads the sample data again.';

  @override
  String get resetDemoConfirm => 'Reset';

  @override
  String get resetDone => 'Sample data loaded again';

  @override
  String get sectionAbout => 'About';

  @override
  String get licenses => 'Open-source licenses';

  @override
  String get welcomeTitle => 'Welcome to ICare';

  @override
  String welcomeBody(String name) {
    return 'Keep track of $name\'s care together: who gave each dose and when, stock, appointments and notes.';
  }

  @override
  String get welcomeSample => 'Everything here is sample data. Try it freely.';

  @override
  String get welcomeWho => 'Who\'s using this phone?';

  @override
  String get welcomeStart => 'Got it';
}
