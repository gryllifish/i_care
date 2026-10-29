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
  String get nextDose => 'Próxima toma';

  @override
  String get allDoneToday => 'Todas las tomas de hoy están registradas.';

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
  String careOf(String name) {
    return 'Cuidando a $name';
  }

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
}
