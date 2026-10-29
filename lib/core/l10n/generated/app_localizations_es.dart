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
  String get fromYesterday => 'De ayer';

  @override
  String get dayPartMorning => 'Mañana';

  @override
  String get dayPartMidday => 'Mediodía';

  @override
  String get dayPartAfternoon => 'Tarde';

  @override
  String get dayPartNight => 'Noche';

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
  String get whoAreYou => '¿Quién sos?';

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
      'Dos teléfonos sincronizados con un servidor simulado. Para simular una toma registrada tarde: desconectá el de Martín, marcá la misma toma en los dos y volvé a conectarlo.';

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
  String get dayDone => 'Todas las tomas de hoy están registradas';

  @override
  String dayProgress(int done, int total) {
    return '$done de $total tomas registradas hoy';
  }

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
  String get fieldWhen => 'Fecha y hora';

  @override
  String get sectionQuestions => 'Preguntas para el médico';

  @override
  String get fieldQuestionsHint => 'Una por línea';

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
  String get nextAppointment => 'Próximo turno';

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
  String get handoffSubtitle => 'Un resumen para quien sigue';

  @override
  String handoffHeader(String name, String day, String time) {
    return 'Relevo de $name · $day, $time';
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
  String get copy => 'Copiar';
}
