/// Deployment environment selected at build time.
enum AppEnvironment { dev, staging, prod }

/// Build-time configuration read from `--dart-define-from-file`.
///
/// Values live in `env/<environment>.json` (git-ignored; see
/// `env/dev.json.example`). Never hardcode secrets here.
abstract final class Env {
  static const _environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static final AppEnvironment environment = AppEnvironment.values.byName(
    _environmentName,
  );
}
