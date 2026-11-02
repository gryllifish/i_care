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
  String get givenToo => 'I gave it too';

  @override
  String removeRecordOf(String name) {
    return 'Remove $name\'s record';
  }

  @override
  String get removeRecordTitle => 'Remove this record?';

  @override
  String removeGivenBody(String name, String time) {
    return '$name recorded it as given at $time. Remove it only if the dose was not given. The change shows in Activity.';
  }

  @override
  String removeSkippedBody(String name) {
    return '$name recorded it as skipped. Remove it if the dose is still to be given. The change shows in Activity.';
  }

  @override
  String get recordRemoved => 'Record removed';

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
  String phoneOf(String name) {
    return '$name\'s phone';
  }

  @override
  String get networkOn => 'Connected';

  @override
  String get networkOff => 'Offline';

  @override
  String get demoHint =>
      'Two phones synced through a simulated server: Ana coordinates as admin, Rosa helps with today\'s care. To simulate a dose recorded twice: turn Rosa\'s phone off, mark the same dose on both and turn it back on. Ana reviews it.';

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
  String get fieldDay => 'Day';

  @override
  String get fieldTime => 'Time';

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
  String get sectionLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

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
  String get welcomeStart => 'Got it';

  @override
  String get unknownTask => 'a task';

  @override
  String activityTaskCreated(String name, String task) {
    return '$name added the task $task';
  }

  @override
  String activityTaskUpdated(String name, String task) {
    return '$name changed the task $task';
  }

  @override
  String activityTaskArchived(String name, String task) {
    return '$name archived the task $task';
  }

  @override
  String activityTaskDone(String name, String task) {
    return '$name did: $task';
  }

  @override
  String activityTaskSkipped(String name, String task, String reason) {
    return '$name skipped $task: $reason';
  }

  @override
  String get statusToDoToday => 'To do today';

  @override
  String get statusDone => 'Done';

  @override
  String get duringTheDay => 'During the day';

  @override
  String get markDone => 'Mark as done';

  @override
  String get markNotDone => 'Not done';

  @override
  String get taskSkipReasonTitle => 'Why wasn\'t it done?';

  @override
  String taskRecordedDone(String task) {
    return '$task: done';
  }

  @override
  String taskRecordedSkipped(String task) {
    return '$task: not done';
  }

  @override
  String get taskRecords => 'Recorded';

  @override
  String removeDoneBody(String name, String time) {
    return '$name marked it as done at $time. Remove it only if it wasn\'t done. The change shows in Activity.';
  }

  @override
  String removeTaskSkippedBody(String name) {
    return '$name marked it as not done. Remove it if it is still to do. The change shows in Activity.';
  }

  @override
  String get navTasks => 'Tasks';

  @override
  String tasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String get tasksEmpty =>
      'No tasks yet. Add care that isn\'t a medication, like a bath, a walk or a skin check.';

  @override
  String get newTask => 'New task';

  @override
  String get editTask => 'Edit task';

  @override
  String get sectionTask => 'Task';

  @override
  String get fieldTaskNameHint => 'e.g. Bath';

  @override
  String get fieldTaskNoteHint => 'e.g. Use the shower chair';

  @override
  String get sectionWhen => 'When';

  @override
  String get taskAtSetTimes => 'At set times';

  @override
  String get handoffTasksDone => 'Tasks done today:';

  @override
  String get handoffTasksSkipped => 'Tasks not done today:';

  @override
  String get handoffTasksPending => 'Tasks still to do:';

  @override
  String get tabMedications => 'Meds';

  @override
  String get tabAppointments => 'Visits';

  @override
  String activityDocumentLinked(String name, String document, String title) {
    return '$name added $document to the $title appointment';
  }

  @override
  String activityDocumentRemoved(String name, String title) {
    return '$name removed a document from the $title appointment';
  }

  @override
  String get documentsTitle => 'Studies and documents';

  @override
  String get documentsEmpty =>
      'Keep links to results, reports or orders here, so they are at hand at the visit.';

  @override
  String get addLink => 'Add link';

  @override
  String get newLinkTitle => 'New link';

  @override
  String get fieldDocumentTitle => 'What it is';

  @override
  String get fieldDocumentTitleHint => 'e.g. Blood test results';

  @override
  String get fieldDocumentUrl => 'Link';

  @override
  String get fieldDocumentUrlHint => 'Paste the address';

  @override
  String get linkOnlyNote =>
      'ICare keeps the link, not the file: it opens wherever the document already is, like the lab\'s website or a shared folder.';

  @override
  String get issueDocumentTitle => 'Enter what it is';

  @override
  String get issueDocumentUrl =>
      'Enter a web address, like lab.example.com/results';

  @override
  String removeDocument(String document) {
    return 'Remove $document';
  }

  @override
  String removeDocumentTitle(String document) {
    return 'Remove $document?';
  }

  @override
  String get removeDocumentBody =>
      'The link is taken off this appointment. The change shows in Activity.';

  @override
  String get linkAdded => 'Link added';

  @override
  String get openLinkFailed => 'Couldn\'t open the link';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return '$_temp0';
  }

  @override
  String get handoffDocuments => 'Documents for it:';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleCaregiver => 'Caregiver';

  @override
  String get roleHelper => 'Helper';

  @override
  String get roleViewer => 'View only';

  @override
  String activityMemberInvited(String name, String member, String role) {
    return '$name invited $member ($role)';
  }

  @override
  String activityInvitationRevoked(String name, String member) {
    return '$name withdrew $member\'s invitation';
  }

  @override
  String activityMemberJoined(String member) {
    return '$member joined the circle';
  }

  @override
  String activityRoleChanged(String name, String member, String role) {
    return '$name changed $member\'s role to $role';
  }

  @override
  String activityMemberRemoved(String name, String member) {
    return '$name removed $member from the circle';
  }

  @override
  String activityMemberLeft(String member) {
    return '$member left the circle on a phone';
  }

  @override
  String get circleTitle => 'The circle';

  @override
  String get thisPhone => 'This phone';

  @override
  String get memberInvitedStatus => 'Invited';

  @override
  String circleButtonLabel(String name) {
    return '$name, on this phone. See the circle';
  }

  @override
  String syncRejected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records not sent',
      one: '1 record not sent',
    );
    return '$_temp0';
  }

  @override
  String get sectionNotSent => 'Not sent';

  @override
  String get notSentNote =>
      'The server refused these records, so nobody else has them and the app shows them nowhere else.';

  @override
  String get rejectedWrongAuthor => 'It was written as someone else.';

  @override
  String get rejectedNotAllowed => 'Your role does not allow it.';

  @override
  String get rejectedNotMember => 'You are no longer in the circle.';

  @override
  String get rejectedLastAdmin => 'The circle would be left without an admin.';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get afterAccessEnded => 'After their access ended';

  @override
  String get errorNotMember => 'This phone is not in the circle any more.';

  @override
  String get errorForbidden => 'Your role does not allow it.';

  @override
  String get errorCodeUnknown =>
      'That code does not exist. Check it with whoever sent it.';

  @override
  String get errorCodeUsed => 'That code was already used. Ask for a new one.';

  @override
  String get errorCodeExpired => 'That code expired. Ask for a new one.';

  @override
  String get joinTitle => 'Join a care circle';

  @override
  String get joinBody =>
      'Ask an admin of the circle for a code. It works once, for 48 hours.';

  @override
  String get fieldCode => 'Code';

  @override
  String get fieldCodeHint => 'e.g. K7P-4QM';

  @override
  String get join => 'Join';

  @override
  String get joinDemoHint =>
      'In this demo, make a code on Ana\'s phone: Settings, The circle, tap someone, New code.';

  @override
  String get removedTitle => 'This phone is out of the circle';

  @override
  String get removedBody =>
      'An admin took you out of the circle. Anything this phone had not sent was sent first; what it kept is cleared now.';

  @override
  String get removedOk => 'OK';

  @override
  String get inviteSomeone => 'Invite someone';

  @override
  String get inviteTitle => 'Invite to the circle';

  @override
  String get fieldRole => 'Role';

  @override
  String get invite => 'Invite';

  @override
  String get roleAdminAbout => 'Everything, including who belongs.';

  @override
  String get roleCaregiverAbout => 'Daily care: medications, tasks and visits.';

  @override
  String get roleHelperAbout => 'Today\'s doses and tasks only.';

  @override
  String get roleViewerAbout => 'Sees everything, changes nothing.';

  @override
  String codeTitle(String name) {
    return 'Code for $name';
  }

  @override
  String codeValidUntil(String when) {
    return 'Works once, until $when.';
  }

  @override
  String get codeShareHint =>
      'Send it however you like. On the new phone, enter it to join.';

  @override
  String get copyCode => 'Copy code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get close => 'Close';

  @override
  String get newCode => 'New code';

  @override
  String get newCodeAbout =>
      'For another device, or if the last code was lost. The previous one stops working.';

  @override
  String get withdrawInvitation => 'Withdraw invitation';

  @override
  String withdrawTitle(String name) {
    return 'Withdraw $name\'s invitation?';
  }

  @override
  String get withdrawBody => 'Their code stops working.';

  @override
  String get removeMember => 'Remove from the circle';

  @override
  String removeMemberTitle(String name) {
    return 'Remove $name from the circle?';
  }

  @override
  String get removeMemberBody =>
      'Their phones stop syncing and clear what they kept. Their records stay in Activity.';

  @override
  String get lastAdminNote => 'The circle needs at least one admin.';

  @override
  String get leaveCircle => 'Leave the circle on this phone';

  @override
  String get leaveTitle => 'Leave the circle on this phone?';

  @override
  String get leaveBody =>
      'Anything not sent yet is sent first, then this phone\'s copy is cleared. Coming back takes a new code.';

  @override
  String get leave => 'Leave';

  @override
  String get leaveOffline =>
      'Connect to leave: there are records still to send.';

  @override
  String get conflictNeedsReviewer => 'An admin or a caregiver will review it.';

  @override
  String get daySummaryTitle => 'Today so far';

  @override
  String get summaryNothingLate => 'Nothing late';

  @override
  String summaryLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count late',
      one: '1 late',
    );
    return '$_temp0';
  }

  @override
  String summaryTasks(int done, int total) {
    return 'Tasks: $done of $total';
  }

  @override
  String summaryLast(String record, String time) {
    return 'Last: $record, at $time.';
  }

  @override
  String get summaryNothingYet => 'Nothing recorded today yet.';

  @override
  String activityReasonAdded(String name, String reason) {
    return '$name added the reason \"$reason\"';
  }

  @override
  String activityReasonHidden(String name, String reason) {
    return '$name stopped offering \"$reason\"';
  }

  @override
  String activityReasonShown(String name, String reason) {
    return '$name offered \"$reason\" again';
  }

  @override
  String get skipOtherField => 'What happened?';

  @override
  String get skipOtherSave => 'Save';

  @override
  String get sectionReasons => 'Reasons for not giving or doing';

  @override
  String get reasonsNote =>
      'Offered when a dose is not given or a task not done. \"Other\" is always there, to write what happened.';

  @override
  String get reasonMedicationsOnly => 'Medications only';

  @override
  String get reasonOwn => 'Added by the circle';

  @override
  String get fieldNewReason => 'New reason';

  @override
  String get fieldNewReasonHint => 'e.g. At the hospital';

  @override
  String get addReason => 'Add reason';

  @override
  String get reasonExists => 'Enter a reason that is not on the list.';
}
