import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/datasources/google_account_source.dart';
import 'package:i_care/features/care/data/sync/access_gateway.dart';

/// Google's own account sheet on Android (`google_sign_in`). It asks for
/// an ID token meant for [_serverClientId], the web client the backend
/// checks tokens against; Google knows the app by its package and
/// signing key. Google's types never leave this class.
class GoogleSignInAccountSource implements GoogleAccountSource {
  GoogleSignInAccountSource(this._google, {required this._serverClientId});

  final GoogleSignIn _google;
  final String _serverClientId;
  Future<void>? _ready;

  @override
  Future<GoogleCredential?> pick() async {
    try {
      await (_ready ??= _google.initialize(serverClientId: _serverClientId));
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const GoogleSignInFailedException('Google gave no ID token');
      }
      return (idToken: idToken, accessToken: null, email: account.email);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw GoogleSignInFailedException(
        'Google sign-in failed: ${error.code.name}',
        cause: error,
      );
      // The plugin's channel reports some failures as its own type.
    } on PlatformException catch (error) {
      throw GoogleSignInFailedException(
        'Google sign-in failed: ${error.code}',
        cause: error,
      );
    } finally {
      await _forget();
    }
  }

  /// The token is all that is needed: without Google's own session, the
  /// sheet asks which account every time.
  Future<void> _forget() async {
    try {
      await _google.signOut();
    } on Exception catch (error, stackTrace) {
      AppLogger.warning('Google session not cleared', error, stackTrace);
    }
  }
}
