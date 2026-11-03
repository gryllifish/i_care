/// Deployment environment selected at build time.
enum AppEnvironment { dev, staging, prod }

/// Where the shared log lives (`docs/backend.md`).
enum SyncBackend {
  /// The demo: simulated phones and server, in the app itself.
  simulated,

  /// The beta: this phone alone, syncing with a Supabase project.
  supabase,
}

/// Build-time configuration read from `--dart-define-from-file`.
///
/// Values live in `env/<environment>.json` (git-ignored; see
/// `env/*.json.example`). Never hardcode secrets here.
abstract final class Env {
  static const _environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static final AppEnvironment environment = AppEnvironment.values.byName(
    _environmentName,
  );

  static const _syncBackendName = String.fromEnvironment(
    'SYNC_BACKEND',
    defaultValue: 'simulated',
  );

  static final SyncBackend syncBackend = SyncBackend.values.byName(
    _syncBackendName,
  );

  /// The Supabase project's URL, for [SyncBackend.supabase].
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// The project's publishable key: meant for apps, and safe in one, since
  /// the database only answers through functions that check the caller.
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
}
