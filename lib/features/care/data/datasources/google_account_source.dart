import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/sync/access_gateway.dart';

/// Google's account picker on this phone.
abstract interface class GoogleAccountSource {
  /// The account the person picks; null when they close the picker.
  ///
  /// Throws [GoogleSignInFailedException].
  Future<GoogleCredential?> pick();
}
