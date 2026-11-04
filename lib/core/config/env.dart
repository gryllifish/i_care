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

  // Firebase, used for push notifications only (`docs/backend.md`). These
  // identify the project; they are public, shipped in every app.
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const firebaseSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const firebaseAndroidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
  );
  static const firebaseWebAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');

  /// The web push certificate's public key.
  static const firebaseVapidKey = String.fromEnvironment('FIREBASE_VAPID_KEY');

  /// Whether this build can receive push notifications.
  static bool get hasFirebase =>
      firebaseApiKey.isNotEmpty && firebaseProjectId.isNotEmpty;
}
