// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ICare';

  @override
  String get retry => 'Reintentar';

  @override
  String get todayTitle => 'Hoy';

  @override
  String get medicalDisclaimer =>
      'ICare ayuda a coordinar el cuidado entre varias personas. No da consejo médico: seguí las indicaciones del médico o farmacéutico tratante.';

  @override
  String get errorLoadData => 'No pudimos leer los datos guardados.';

  @override
  String get errorNotFound => 'No encontramos ese elemento.';

  @override
  String get errorUnexpected => 'Algo salió mal. Probá de nuevo.';

  @override
  String get errorOffline =>
      'Estás sin conexión. Los cambios quedan guardados en este dispositivo y se sincronizan al volver la conexión.';

  @override
  String get errorTimeout => 'Está tardando demasiado. Probá de nuevo.';

  @override
  String get errorServer =>
      'El servicio de sincronización tiene problemas. Probá en un rato.';

  @override
  String get sampleData => 'Datos de ejemplo';

  @override
  String syncedAt(String time) {
    return 'Sincronizado a las $time';
  }

  @override
  String get syncNever => 'Todavía sin sincronizar';

  @override
  String get syncOffline => 'Sin conexión';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cambios sin enviar',
      one: '1 cambio sin enviar',
    );
    return '$_temp0';
  }

  @override
  String get asNeeded => 'Si hace falta';

  @override
  String get statusUpcoming => 'Pendiente';

  @override
  String get statusDue => 'Es la hora';

  @override
  String get statusOverdue => 'Atrasada';

  @override
  String get statusGiven => 'Dada';

  @override
  String get statusSkipped => 'Omitida';

  @override
  String get statusGivenTwice => 'Dada 2 veces';

  @override
  String recordedBy(String name, String time) {
    return '$name, a las $time';
  }

  @override
  String lastDose(String time, String name) {
    return 'Última: $time, por $name';
  }

  @override
  String get noDoseYet => 'Sin dosis registradas';

  @override
  String stockDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Quedan $days días',
      one: 'Queda 1 día',
      zero: 'Se termina hoy',
    );
    return '$_temp0';
  }

  @override
  String get stockOut => 'Sin stock';

  @override
  String get doubleDoseBody =>
      'Registrada como dada más de una vez. Si tenés dudas, consultá con su médico o farmacéutico.';

  @override
  String get markGiven => 'Marcar como dada';

  @override
  String get markGivenAnyway => 'Marcar como dada igual';

  @override
  String get givenToo => 'Yo también se la di';

  @override
  String removeRecordOf(String name) {
    return 'Quitar el registro de $name';
  }

  @override
  String get removeRecordTitle => '¿Quitar este registro?';

  @override
  String removeGivenBody(String name, String time) {
    return '$name la registró como dada a las $time. Quitalo solo si la toma no se dio. El cambio queda en Actividad.';
  }

  @override
  String removeSkippedBody(String name) {
    return '$name la registró como omitida. Quitalo si la toma sigue pendiente. El cambio queda en Actividad.';
  }

  @override
  String get recordRemoved => 'Registro quitado';

  @override
  String get skipDose => 'Omitir esta toma';

  @override
  String get skipReasonTitle => '¿Por qué se omite?';

  @override
  String get skipRefused => 'No la quiso';

  @override
  String get skipAsleep => 'Estaba durmiendo';

  @override
  String get skipUnwell => 'Se sentía mal';

  @override
  String get skipDoctorAdvice => 'Indicación médica';

  @override
  String get skipOther => 'Otro motivo';

  @override
  String skippedBy(String name, String reason) {
    return 'Omitida por $name: $reason';
  }

  @override
  String doseRecordedGiven(String medication) {
    return '$medication: registrada como dada';
  }

  @override
  String doseRecordedSkipped(String medication) {
    return '$medication: registrada como omitida';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get checkBeforeGiving => 'Revisá antes de darla';

  @override
  String warningAlreadyGiven(String name, String time) {
    return '$name ya la registró a las $time.';
  }

  @override
  String warningTooSoon(String last, String next) {
    return 'La última dosis fue a las $last. Con el intervalo que cargaste, la próxima es desde las $next.';
  }

  @override
  String warningDailyLimit(int given, int max) {
    return 'Hoy ya se dieron $given de $max dosis, el máximo que cargaste.';
  }

  @override
  String warningOutOfDate(String time) {
    return 'Este teléfono se sincronizó por última vez a las $time: puede que alguien ya la haya dado.';
  }

  @override
  String get warningNeverSynced =>
      'Este teléfono todavía no se sincronizó: puede que alguien ya la haya dado.';

  @override
  String scheduledAt(String time) {
    return 'Programada a las $time';
  }

  @override
  String get recordedToday => 'Registrado hoy';

  @override
  String get recordedForThisDose => 'Registrado para esta toma';

  @override
  String get unknownCaregiver => 'Alguien';

  @override
  String phoneOf(String name) {
    return 'Teléfono de $name';
  }

  @override
  String get networkOn => 'Con conexión';

  @override
  String get networkOff => 'Sin conexión';

  @override
  String get demoHint =>
      'Dos teléfonos sincronizados con un servidor simulado: Ana coordina como admin, Rosa ayuda con el cuidado del día. Para simular una toma registrada dos veces: desconectá el teléfono de Rosa, marcá la misma toma en los dos y volvé a conectarlo. Ana la revisa.';

  @override
  String get yesterday => 'Ayer';

  @override
  String get notSyncedYet => 'Aún no sincronizada';

  @override
  String conflictSlotTitle(String medication, String time, int count) {
    return '$medication de las $time se registró $count veces';
  }

  @override
  String conflictCloseTitle(String medication) {
    return '$medication: dosis muy seguidas';
  }

  @override
  String get conflictExplanation =>
      'Se registraron en teléfonos distintos, sin ver el registro del otro.';

  @override
  String conflictQuestion(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿$name recibió las $count dosis?',
      two: '¿$name recibió las dos dosis?',
    );
    return '$_temp0';
  }

  @override
  String get conflictOnlyOne => 'No, fue una sola';

  @override
  String conflictAllGiven(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sí, se dieron todas',
      two: 'Sí, se dieron las dos',
    );
    return '$_temp0';
  }

  @override
  String get conflictNotSure => 'Todavía no sé';

  @override
  String get conflictResolvedOne => 'Se anuló el registro repetido';

  @override
  String conflictArrived(String medication) {
    return '$medication se registró más de una vez';
  }

  @override
  String get review => 'Revisar';

  @override
  String get warningOffline =>
      'Este teléfono está sin conexión: puede que alguien ya la haya dado.';

  @override
  String doseRecordedOffline(String medication) {
    return '$medication: guardada en este teléfono. Se enviará al volver la conexión.';
  }

  @override
  String recordedByToday(String name, String time) {
    return '$name, hoy a las $time';
  }

  @override
  String get givenWhen => '¿Cuándo la diste?';

  @override
  String get givenNow => 'Ahora';

  @override
  String givenMinutesAgo(int minutes) {
    return 'Hace $minutes min';
  }

  @override
  String givenHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Hace $hours horas',
      one: 'Hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String get givenPickTime => 'Elegir hora';

  @override
  String givenAtTime(String time) {
    return 'A las $time';
  }

  @override
  String get navToday => 'Hoy';

  @override
  String get navMedications => 'Medicamentos';

  @override
  String get navActivity => 'Actividad';

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
    return 'Próxima toma · en $duration';
  }

  @override
  String get nextDueNow => 'Próxima toma · es la hora';

  @override
  String nextLate(String duration) {
    return 'Atrasada · $duration';
  }

  @override
  String get nextFromYesterday => 'De ayer · atrasada';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String medicationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count medicamentos activos',
      one: '1 medicamento activo',
    );
    return '$_temp0';
  }

  @override
  String get everyDay => 'Todos los días';

  @override
  String minIntervalText(String duration) {
    return 'con al menos $duration entre dosis';
  }

  @override
  String maxPerDayText(int count) {
    return 'hasta $count por día';
  }

  @override
  String get stockNotCounted => 'Stock sin contar';

  @override
  String get today => 'Hoy';

  @override
  String get activityEmpty => 'Todavía no hay registros';

  @override
  String activityCreated(String name, String medication) {
    return '$name agregó $medication';
  }

  @override
  String activityUpdated(String name, String medication) {
    return '$name editó $medication';
  }

  @override
  String activityScheduleChanged(String name, String medication) {
    return '$name cambió el horario de $medication';
  }

  @override
  String activityArchived(String name, String medication) {
    return '$name archivó $medication';
  }

  @override
  String activityGiven(String name, String medication) {
    return '$name dio $medication';
  }

  @override
  String activityGivenSlot(String name, String medication, String time) {
    return '$name dio $medication de las $time';
  }

  @override
  String activitySkipped(
    String name,
    String medication,
    String time,
    String reason,
  ) {
    return '$name omitió $medication de las $time: $reason';
  }

  @override
  String activityUndone(String name, String medication) {
    return '$name anuló un registro de $medication';
  }

  @override
  String activityCounted(String name, String medication, String units) {
    return '$name contó $medication: $units';
  }

  @override
  String activityRefilled(String name, String medication, String units) {
    return '$name sumó $units de $medication';
  }

  @override
  String activityReviewed(String name) {
    return '$name revisó una toma registrada 2 veces';
  }

  @override
  String get unknownMedication => 'un medicamento';

  @override
  String givenAtLabel(String time) {
    return 'dada a las $time';
  }

  @override
  String get caringFor => 'Cuidando a';

  @override
  String stockUnitsCount(String units) {
    return '$units unidades';
  }

  @override
  String stockLasts(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Alcanza para $days días',
      one: 'Alcanza para 1 día',
    );
    return '$_temp0';
  }

  @override
  String get add => 'Agregar';

  @override
  String get newMedication => 'Nuevo medicamento';

  @override
  String get editMedication => 'Editar medicamento';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get fieldName => 'Nombre';

  @override
  String get fieldStrength => 'Concentración';

  @override
  String get fieldStrengthHint => 'Ej.: 500 mg';

  @override
  String get fieldForm => 'Forma';

  @override
  String get fieldInstructions => 'Indicaciones (opcional)';

  @override
  String get fieldInstructionsHint => 'Ej.: Con las comidas';

  @override
  String get fieldUnitsPerDose => 'Unidades por toma';

  @override
  String get fieldLowStockDays => 'Avisar cuando el stock alcance para';

  @override
  String daysValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get fieldInitialStock => 'Unidades en stock (opcional)';

  @override
  String get prescriptionNote =>
      'Cargá los datos tal como figuran en la receta. ICare no sugiere dosis.';

  @override
  String get formTablet => 'Comprimido';

  @override
  String get formCapsule => 'Cápsula';

  @override
  String get formLiquid => 'Líquido';

  @override
  String get formDrops => 'Gotas';

  @override
  String get formInjection => 'Inyección';

  @override
  String get formPatch => 'Parche';

  @override
  String get formInhaler => 'Inhalador';

  @override
  String get formOther => 'Otra';

  @override
  String get scheduleTitle => 'Horario';

  @override
  String get scheduleFixed => 'Horario fijo';

  @override
  String get scheduleAsNeeded => 'Si hace falta';

  @override
  String get addTime => 'Agregar hora';

  @override
  String removeTime(String time) {
    return 'Quitar $time';
  }

  @override
  String get whichDays => 'Qué días';

  @override
  String get minIntervalOptional => 'Tiempo mínimo entre dosis (opcional)';

  @override
  String get minIntervalLabel => 'Tiempo mínimo entre dosis';

  @override
  String get maxPerDayLabel => 'Máximo por día (opcional)';

  @override
  String hoursValue(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String get noLimit => 'Sin límite';

  @override
  String get issueNameMissing => 'Escribí el nombre';

  @override
  String get issueUnitsPerDose => 'Las unidades por toma deben ser más de 0';

  @override
  String get issueNoTimes => 'Agregá al menos una hora';

  @override
  String get issueMinInterval => 'El tiempo entre dosis debe ser más de 0';

  @override
  String get issueMaxPerDay => 'El máximo por día debe ser al menos 1';

  @override
  String get issueStockNumber => 'Escribí un número';

  @override
  String get changeSchedule => 'Cambiar horario';

  @override
  String get scheduleFromWhen => '¿Desde cuándo?';

  @override
  String get fromNow => 'Ahora';

  @override
  String get fromTomorrow => 'Mañana';

  @override
  String get fromPickDate => 'Elegir fecha';

  @override
  String fromDate(String date) {
    return 'Desde el $date';
  }

  @override
  String get earlierDosesUnchanged => 'Las tomas anteriores no cambian.';

  @override
  String get previousSchedules => 'Horarios anteriores';

  @override
  String scheduleUntil(String date) {
    return 'Hasta el $date';
  }

  @override
  String get stockTitle => 'Stock';

  @override
  String get recount => 'Recontar';

  @override
  String get boughtMore => 'Compré más';

  @override
  String get howManyLeft => '¿Cuántas quedan?';

  @override
  String get howManyBought => '¿Cuántas compraste?';

  @override
  String get recentDoses => 'Últimas tomas';

  @override
  String get instructionsTitle => 'Indicaciones';

  @override
  String get archive => 'Archivar';

  @override
  String archiveTitle(String medication) {
    return '¿Archivar $medication?';
  }

  @override
  String get archiveBody =>
      'Deja de aparecer en Hoy y en la lista. Su historial queda en Actividad.';

  @override
  String get archived => 'Archivado';

  @override
  String medicationSaved(String medication) {
    return '$medication: guardado';
  }

  @override
  String medicationSavedFirstDose(String medication, String when) {
    return '$medication: guardado · Primera toma: $when';
  }

  @override
  String nextDoseLater(String medication, String when) {
    return 'Próxima toma: $medication, $when';
  }

  @override
  String get editConflictTitle =>
      'Cambiado por más de una persona al mismo tiempo';

  @override
  String get editConflictBody =>
      'Quedó el último cambio recibido. Elegí cuál mantener.';

  @override
  String get keepThis => 'Mantener este';

  @override
  String get useThis => 'Usar este';

  @override
  String get inUse => 'En uso';

  @override
  String changeBy(String name, String time) {
    return '$name, a las $time';
  }

  @override
  String get changeArchived => 'Lo archivó';

  @override
  String get medicationConflictBadge => 'Para revisar';

  @override
  String get more => 'Más';

  @override
  String get back => 'Volver';

  @override
  String get issueNoWeekdays => 'Elegí al menos un día';

  @override
  String get pickDays => 'Elegir días';

  @override
  String get done => 'Listo';

  @override
  String get sectionMedication => 'Medicamento';

  @override
  String get sectionDoseAndStock => 'Dosis y stock';

  @override
  String get sectionFromWhen => 'Desde cuándo';

  @override
  String get unknownAppointment => 'un turno';

  @override
  String activityAppointmentCreated(String name, String title) {
    return '$name agregó el turno de $title';
  }

  @override
  String activityAppointmentUpdated(String name, String title) {
    return '$name editó el turno de $title';
  }

  @override
  String activityAppointmentCancelled(String name, String title) {
    return '$name canceló el turno de $title';
  }

  @override
  String activityVisitNote(String name, String title) {
    return '$name agregó una nota al turno de $title';
  }

  @override
  String get navAppointments => 'Turnos';

  @override
  String get upcomingTitle => 'Próximos';

  @override
  String get pastTitle => 'Pasados';

  @override
  String get appointmentsEmpty => 'Todavía no hay turnos';

  @override
  String get noNotesPrompt => 'Sin notas: agregá lo que dijo el médico';

  @override
  String questionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas para hacer',
      one: '1 pregunta para hacer',
    );
    return '$_temp0';
  }

  @override
  String notesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notas',
      one: '1 nota',
    );
    return '$_temp0';
  }

  @override
  String get newAppointment => 'Nuevo turno';

  @override
  String get editAppointment => 'Editar turno';

  @override
  String get sectionAppointment => 'Turno';

  @override
  String get fieldTitle => 'Especialidad o motivo';

  @override
  String get fieldTitleHint => 'Ej.: Cardiología';

  @override
  String get fieldDoctor => 'Médico (opcional)';

  @override
  String get fieldLocation => 'Lugar (opcional)';

  @override
  String get fieldDay => 'Día';

  @override
  String get fieldTime => 'Hora';

  @override
  String get sectionQuestions => 'Preguntas para el médico';

  @override
  String get fieldQuestionsHint => 'Escribí una pregunta';

  @override
  String get addQuestion => 'Agregar pregunta';

  @override
  String get removeQuestion => 'Quitar pregunta';

  @override
  String get issueTitleMissing => 'Escribí la especialidad o el motivo';

  @override
  String get visitNotes => 'Notas de la visita';

  @override
  String get addNoteHint => '¿Qué dijo el médico?';

  @override
  String get addNote => 'Agregar nota';

  @override
  String get cancelAppointment => 'Cancelar turno';

  @override
  String cancelAppointmentTitle(String title) {
    return '¿Cancelar el turno de $title?';
  }

  @override
  String get cancelAppointmentBody =>
      'Deja de aparecer en la lista. Sus notas quedan en Actividad.';

  @override
  String get keepAppointment => 'No, mantener';

  @override
  String get cancelled => 'Cancelado';

  @override
  String todayAt(String time) {
    return 'Hoy, $time';
  }

  @override
  String tomorrowAt(String time) {
    return 'Mañana, $time';
  }

  @override
  String dayAt(String day, String time) {
    return '$day, $time';
  }

  @override
  String get changeCancelled => 'Lo canceló';

  @override
  String get newNote => 'Nueva nota';

  @override
  String activityProfileUpdated(String name) {
    return '$name actualizó la ficha de emergencia';
  }

  @override
  String get emergencyCard => 'Ficha de emergencia';

  @override
  String ageYears(int years) {
    return '$years años';
  }

  @override
  String get allergiesTitle => 'Alergias';

  @override
  String get noAllergies => 'Sin alergias conocidas';

  @override
  String get conditionsTitle => 'Condiciones';

  @override
  String get medicationsTitle => 'Medicación';

  @override
  String get doctorsTitle => 'Médicos';

  @override
  String get contactsTitle => 'Contactos de emergencia';

  @override
  String get notesTitle => 'Notas';

  @override
  String get copyAsText => 'Copiar como texto';

  @override
  String get copied =>
      'Copiada. Pegala en un mensaje o mostrala en la guardia.';

  @override
  String callName(String name) {
    return 'Llamar a $name';
  }

  @override
  String get callFailed => 'No se pudo abrir el teléfono';

  @override
  String get emptyProfile => 'Todavía nadie completó la ficha de emergencia.';

  @override
  String get fillIn => 'Completarla';

  @override
  String get editProfile => 'Editar ficha';

  @override
  String get sectionPerson => 'Persona';

  @override
  String get fieldFullName => 'Nombre completo';

  @override
  String get fieldBirthDate => 'Fecha de nacimiento (opcional)';

  @override
  String get notSet => 'Sin cargar';

  @override
  String get fieldAllergies => 'Alergias (una por línea)';

  @override
  String get fieldConditions => 'Condiciones (una por línea)';

  @override
  String get fieldNotes => 'Notas (opcional)';

  @override
  String get addDoctor => 'Agregar médico';

  @override
  String get addContact => 'Agregar contacto';

  @override
  String get fieldPersonName => 'Nombre';

  @override
  String get fieldSpecialty => 'Especialidad';

  @override
  String get fieldRelationship => 'Relación';

  @override
  String get fieldPhone => 'Teléfono';

  @override
  String get remove => 'Quitar';

  @override
  String get handoffTitle => 'Te dejo dicho';

  @override
  String get handoffSubtitle =>
      'Notas para quien sigue. Las ve todo el círculo.';

  @override
  String handoffHeader(String name, String day, String time) {
    return 'El día de $name · $day, $time';
  }

  @override
  String get handoffGiven => 'Dadas hoy:';

  @override
  String get handoffSkipped => 'Omitidas hoy:';

  @override
  String get handoffPending => 'Falta dar:';

  @override
  String get handoffNothingPending => 'No queda nada por dar hoy.';

  @override
  String handoffConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomas registradas dos veces: revisalas en ICare.',
      one: '1 toma registrada dos veces: revisala en ICare.',
    );
    return '$_temp0';
  }

  @override
  String get handoffLowStock => 'Stock bajo:';

  @override
  String get handoffNextAppointment => 'Próximo turno:';

  @override
  String handoffLastNote(String title, String name) {
    return 'Última nota de visita ($title, $name):';
  }

  @override
  String get handoffCopied => 'Copiado. Pegalo en el chat de la familia.';

  @override
  String get handoffNotes => 'Notas:';

  @override
  String get noteFieldHint => 'Escribí algo para quien sigue';

  @override
  String get leaveNote => 'Dejar nota';

  @override
  String get notesEmpty =>
      'Todavía no hay notas. Lo que escribas acá lo ve todo el círculo.';

  @override
  String get copySummary => 'Copiar resumen del día';

  @override
  String activityCareNote(String name, String text) {
    return '$name dejó dicho: $text';
  }

  @override
  String yesterdayAt(String time) {
    return 'Ayer, $time';
  }

  @override
  String get copy => 'Copiar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get sectionDemo => 'Demo';

  @override
  String get resetDemo => 'Reiniciar datos de ejemplo';

  @override
  String get resetDemoBody =>
      'Borra todo lo registrado en los dos teléfonos y vuelve a cargar los datos de ejemplo.';

  @override
  String get resetDemoBodyOnePhone =>
      'Borra todo lo registrado y vuelve a cargar los datos de ejemplo.';

  @override
  String get resetDemoConfirm => 'Reiniciar';

  @override
  String get resetDone => 'Datos de ejemplo cargados de nuevo';

  @override
  String get sectionAbout => 'Acerca de';

  @override
  String get licenses => 'Licencias de código abierto';

  @override
  String get welcomeTitle => 'Te damos la bienvenida a ICare';

  @override
  String welcomeBody(String name) {
    return 'Coordiná el cuidado de $name entre todos: quién dio cada toma y cuándo, el stock, los turnos y las notas.';
  }

  @override
  String get welcomeSample =>
      'Todo lo que ves son datos de ejemplo. Probá con libertad.';

  @override
  String get welcomeStart => 'Entendido';

  @override
  String get unknownTask => 'una tarea';

  @override
  String activityTaskCreated(String name, String task) {
    return '$name agregó la tarea $task';
  }

  @override
  String activityTaskUpdated(String name, String task) {
    return '$name cambió la tarea $task';
  }

  @override
  String activityTaskArchived(String name, String task) {
    return '$name archivó la tarea $task';
  }

  @override
  String activityTaskDone(String name, String task) {
    return '$name hizo: $task';
  }

  @override
  String activityTaskSkipped(String name, String task, String reason) {
    return '$name omitió $task: $reason';
  }

  @override
  String get statusToDoToday => 'Para hoy';

  @override
  String get statusDone => 'Hecha';

  @override
  String get duringTheDay => 'Durante el día';

  @override
  String get markDone => 'Marcar como hecha';

  @override
  String get markNotDone => 'No se hizo';

  @override
  String get taskSkipReasonTitle => '¿Por qué no se hizo?';

  @override
  String taskRecordedDone(String task) {
    return '$task: hecha';
  }

  @override
  String taskRecordedSkipped(String task) {
    return '$task: no se hizo';
  }

  @override
  String get taskRecords => 'Registros';

  @override
  String removeDoneBody(String name, String time) {
    return '$name la marcó como hecha a las $time. Quitalo solo si no se hizo. El cambio queda en Actividad.';
  }

  @override
  String removeTaskSkippedBody(String name) {
    return '$name la marcó como no hecha. Quitalo si sigue pendiente. El cambio queda en Actividad.';
  }

  @override
  String get navTasks => 'Tareas';

  @override
  String tasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas',
      one: '1 tarea',
    );
    return '$_temp0';
  }

  @override
  String get tasksEmpty =>
      'Todavía no hay tareas. Agregá cuidados que no son medicamentos, como el baño, una caminata o revisar la piel.';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get sectionTask => 'Tarea';

  @override
  String get fieldTaskNameHint => 'Ej.: Baño';

  @override
  String get fieldTaskNoteHint => 'Ej.: usar la silla de ducha';

  @override
  String get sectionWhen => 'Cuándo';

  @override
  String get taskAtSetTimes => 'A horas fijas';

  @override
  String get handoffTasksDone => 'Tareas hechas hoy:';

  @override
  String get handoffTasksSkipped => 'Tareas que no se hicieron hoy:';

  @override
  String get handoffTasksPending => 'Tareas que faltan:';

  @override
  String get tabMedications => 'Remedios';

  @override
  String get tabAppointments => 'Turnos';

  @override
  String activityDocumentLinked(String name, String document, String title) {
    return '$name agregó $document al turno de $title';
  }

  @override
  String activityDocumentRemoved(String name, String title) {
    return '$name quitó un documento del turno de $title';
  }

  @override
  String get documentsTitle => 'Estudios y documentos';

  @override
  String get documentsEmpty =>
      'Guardá acá links a resultados, informes u órdenes, para tenerlos a mano en la visita.';

  @override
  String get addLink => 'Agregar link';

  @override
  String get newLinkTitle => 'Nuevo link';

  @override
  String get fieldDocumentTitle => 'Qué es';

  @override
  String get fieldDocumentTitleHint => 'Ej.: Resultados del análisis';

  @override
  String get fieldDocumentUrl => 'Link';

  @override
  String get fieldDocumentUrlHint => 'Pegá la dirección';

  @override
  String get linkOnlyNote =>
      'ICare guarda el link, no el archivo: se abre donde ya está el documento, como la web del laboratorio o una carpeta compartida.';

  @override
  String get issueDocumentTitle => 'Escribí qué es';

  @override
  String get issueDocumentUrl =>
      'Escribí una dirección web, como lab.example.com/resultados';

  @override
  String removeDocument(String document) {
    return 'Quitar $document';
  }

  @override
  String removeDocumentTitle(String document) {
    return '¿Quitar $document?';
  }

  @override
  String get removeDocumentBody =>
      'El link deja de estar en este turno. El cambio queda en Actividad.';

  @override
  String get linkAdded => 'Link agregado';

  @override
  String get openLinkFailed => 'No se pudo abrir el link';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
    );
    return '$_temp0';
  }

  @override
  String get handoffDocuments => 'Documentos para el turno:';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleCaregiver => 'Cuida a diario';

  @override
  String get roleHelper => 'Ayuda a veces';

  @override
  String get roleViewer => 'Solo lectura';

  @override
  String activityMemberInvited(String name, String member, String role) {
    return '$name invitó a $member ($role)';
  }

  @override
  String activityInvitationRevoked(String name, String member) {
    return '$name retiró la invitación de $member';
  }

  @override
  String activityMemberJoined(String member) {
    return '$member se unió al círculo';
  }

  @override
  String activityRoleChanged(String name, String member, String role) {
    return '$name cambió el rol de $member a $role';
  }

  @override
  String activityMemberRemoved(String name, String member) {
    return '$name quitó a $member del círculo';
  }

  @override
  String activityMemberLeft(String member) {
    return '$member salió del círculo en un teléfono';
  }

  @override
  String get circleTitle => 'El círculo';

  @override
  String get thisPhone => 'Este teléfono';

  @override
  String get memberInvitedStatus => 'Invitado';

  @override
  String syncRejected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros sin enviar',
      one: '1 registro sin enviar',
    );
    return '$_temp0';
  }

  @override
  String get sectionNotSent => 'Sin enviar';

  @override
  String get notSentNote =>
      'El servidor rechazó estos registros: nadie más los tiene y la app no los muestra en ningún otro lugar.';

  @override
  String get rejectedWrongAuthor => 'Quedó escrito a nombre de otra persona.';

  @override
  String get rejectedNotAllowed => 'Tu rol no lo permite.';

  @override
  String get rejectedNotMember => 'Ya no estás en el círculo.';

  @override
  String get rejectedLastAdmin => 'El círculo quedaría sin admin.';

  @override
  String get dismiss => 'Descartar';

  @override
  String get afterAccessEnded => 'Después de que terminó su acceso';

  @override
  String get errorNotMember => 'Este teléfono ya no está en el círculo.';

  @override
  String get errorForbidden => 'Tu rol no lo permite.';

  @override
  String get errorCodeUnknown =>
      'Ese código no existe. Revisalo con quien te lo mandó.';

  @override
  String get errorCodeUsed => 'Ese código ya se usó. Pedí uno nuevo.';

  @override
  String get errorCodeExpired => 'Ese código venció. Pedí uno nuevo.';

  @override
  String get sectionNotifications => 'Notificaciones';

  @override
  String get notificationsOn => 'Los avisos están activados.';

  @override
  String get notificationsOff =>
      'Los avisos están desactivados. Podés activarlos en los ajustes del dispositivo.';

  @override
  String get notificationsTurnOn => 'Activar avisos';

  @override
  String get notificationsBody =>
      'Una nota nueva, un cambio en los turnos o una toma registrada dos veces. Los avisos nunca dicen quién ni qué medicamento.';

  @override
  String get welcomeNotifications =>
      'Al empezar, ICare te va a pedir permiso para avisarte de las novedades del círculo: una nota nueva, un cambio en los turnos o una toma registrada dos veces.';

  @override
  String get errorCodeLocked =>
      'Demasiados códigos incorrectos. Esperá 15 minutos y probá de nuevo.';

  @override
  String get joinTitle => 'Unite a un círculo de cuidado';

  @override
  String get joinBody =>
      'Pedile un código a una persona admin del círculo. Sirve una sola vez, durante 48 horas.';

  @override
  String get fieldCode => 'Código';

  @override
  String get fieldCodeHint => 'Ej.: K7P-4QM';

  @override
  String get join => 'Unirme';

  @override
  String get joinDemoHint =>
      'En esta demo, una persona admin crea códigos en el otro teléfono: Ajustes, El círculo, tocá a alguien, Código nuevo.';

  @override
  String get joinDemoHintOnePhone =>
      'Esta demo tiene un solo teléfono, así que nadie puede darte un código: creá un círculo o volvé a los datos de ejemplo.';

  @override
  String get removedTitle => 'Este teléfono ya no está en el círculo';

  @override
  String get removedBody =>
      'Una persona admin te quitó del círculo. Lo que este teléfono no había enviado se envió antes; ahora se borra lo que tenía guardado.';

  @override
  String get removedOk => 'Entendido';

  @override
  String get inviteSomeone => 'Invitar a alguien';

  @override
  String get inviteTitle => 'Invitar al círculo';

  @override
  String get fieldRole => 'Rol';

  @override
  String get invite => 'Invitar';

  @override
  String get roleAdminAbout => 'Todo, incluido quién forma parte.';

  @override
  String get roleCaregiverAbout =>
      'El cuidado diario: remedios, tareas y turnos.';

  @override
  String get roleHelperAbout => 'Solo las tomas y tareas del día.';

  @override
  String get roleViewerAbout => 'Ve todo, no cambia nada.';

  @override
  String codeTitle(String name) {
    return 'Código para $name';
  }

  @override
  String codeValidUntil(String when) {
    return 'Sirve una vez, hasta $when.';
  }

  @override
  String get codeShareHint =>
      'Mandalo como quieras. En el teléfono nuevo, ingresalo para unirse.';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get close => 'Cerrar';

  @override
  String get newCode => 'Código nuevo';

  @override
  String get newCodeAbout =>
      'Para otro dispositivo, o si se perdió el anterior. El código anterior deja de funcionar.';

  @override
  String get withdrawInvitation => 'Retirar invitación';

  @override
  String withdrawTitle(String name) {
    return '¿Retirar la invitación de $name?';
  }

  @override
  String get withdrawBody => 'Su código deja de funcionar.';

  @override
  String get removeMember => 'Quitar del círculo';

  @override
  String removeMemberTitle(String name) {
    return '¿Quitar a $name del círculo?';
  }

  @override
  String get removeMemberBody =>
      'Sus teléfonos dejan de sincronizar y borran lo que tenían. Sus registros quedan en Actividad.';

  @override
  String get lastAdminNote => 'El círculo necesita al menos una persona admin.';

  @override
  String get leaveCircle => 'Salir del círculo en este teléfono';

  @override
  String get leaveTitle => '¿Salir del círculo en este teléfono?';

  @override
  String get leaveBody =>
      'Primero se envía lo que falta, después se borra lo guardado en este teléfono. Para volver hace falta un código nuevo.';

  @override
  String get leave => 'Salir';

  @override
  String get leaveOffline =>
      'Conectate para salir: quedan registros por enviar.';

  @override
  String get deleteCircle => 'Borrar el círculo y todos sus datos';

  @override
  String deleteCircleTitle(String name) {
    return '¿Borrar todo sobre $name?';
  }

  @override
  String get deleteCircleBody =>
      'Borra el círculo para todos: medicamentos, tomas, tareas, notas, turnos y la ficha de emergencia. Todos los teléfonos salen de él. No se puede deshacer.';

  @override
  String get deleteCircleConfirm => 'Borrar para todos';

  @override
  String get deleteCircleOffline => 'Conectate para borrar el círculo.';

  @override
  String get conflictNeedsReviewer =>
      'Lo va a revisar una persona admin o que cuida a diario.';

  @override
  String get daySummaryTitle => 'El día hasta ahora';

  @override
  String get summaryNothingLate => 'Nada atrasado';

  @override
  String summaryLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atrasadas',
      one: '1 atrasada',
    );
    return '$_temp0';
  }

  @override
  String summaryTasks(int done, int total) {
    return 'Tareas: $done de $total';
  }

  @override
  String summaryLast(String record, String time) {
    return 'Último: $record, a las $time.';
  }

  @override
  String get summaryNothingYet => 'Todavía no hay registros hoy.';

  @override
  String activityReasonAdded(String name, String reason) {
    return '$name agregó el motivo \"$reason\"';
  }

  @override
  String activityReasonHidden(String name, String reason) {
    return '$name dejó de ofrecer \"$reason\"';
  }

  @override
  String activityReasonShown(String name, String reason) {
    return '$name volvió a ofrecer \"$reason\"';
  }

  @override
  String get skipOtherField => '¿Qué pasó?';

  @override
  String get skipOtherSave => 'Guardar';

  @override
  String get sectionReasons => 'Motivos para no dar o no hacer';

  @override
  String get reasonsNote =>
      'Se ofrecen cuando una toma no se da o una tarea no se hace. \"Otro\" siempre está, para escribir qué pasó.';

  @override
  String get reasonMedicationsOnly => 'Solo para remedios';

  @override
  String get reasonOwn => 'Agregado por el círculo';

  @override
  String get fieldNewReason => 'Motivo nuevo';

  @override
  String get fieldNewReasonHint => 'Ej.: En el hospital';

  @override
  String get addReason => 'Agregar motivo';

  @override
  String get editReasons => 'Editar motivos';

  @override
  String get reasonExists => 'Escribí un motivo que no esté en la lista.';

  @override
  String activityCircleCreated(String recipient) {
    return 'Empezó el círculo de $recipient';
  }

  @override
  String get theRecipient => 'la persona que cuidás';

  @override
  String get createCircle => 'Crear un círculo';

  @override
  String get createCircleLead => '¿Empezás un círculo nuevo?';

  @override
  String get createCircleBody =>
      'Vas a ser su admin, e invitar a los demás desde Ajustes.';

  @override
  String get fieldYourName => 'Tu nombre';

  @override
  String get fieldRecipientName => '¿A quién cuidás?';

  @override
  String get fieldRecipientHint => 'Su nombre, ej.: Elena';

  @override
  String get circleExists =>
      'Esta demo ya tiene un círculo. Unite con un código de su admin.';

  @override
  String get exploreSample => 'Explorar con datos de ejemplo';

  @override
  String get startFromScratch => 'Empezar desde cero';

  @override
  String get startEmptyTitle => '¿Empezar desde cero?';

  @override
  String get startEmptyBody =>
      'Se borran los dos teléfonos y el servidor. Creás tu propio círculo y cargás todo vos.';

  @override
  String get startEmptyBodyOnePhone =>
      'Se borra todo. Creás tu propio círculo y cargás todo vos.';

  @override
  String get welcomeDemoChoice =>
      'Solo en esta demo: probala con datos de ejemplo, o vacía, para cargar todo vos.';

  @override
  String phoneNumber(int number) {
    return 'Teléfono $number';
  }

  @override
  String toReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cosas para revisar',
      one: '1 cosa para revisar',
    );
    return '$_temp0';
  }

  @override
  String get notesRowEmpty => 'Dejá una nota para quien sigue';

  @override
  String get notesRowNone => 'No hay notas esta semana';

  @override
  String notePreview(String name, String text) {
    return '$name: $text';
  }

  @override
  String doneOfTotal(int done, int total) {
    return '$done de $total hechas';
  }

  @override
  String resolvedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hechas',
      one: '1 hecha',
    );
    return '$_temp0';
  }

  @override
  String get nothingToday => 'No hay nada programado para hoy.';
}
