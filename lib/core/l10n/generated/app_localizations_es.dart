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
}
