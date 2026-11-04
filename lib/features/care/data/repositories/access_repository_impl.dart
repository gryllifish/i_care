import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/datasources/google_account_source.dart';
import 'package:i_care/features/care/data/repositories/care_repository_impl.dart';
import 'package:i_care/features/care/data/sync/access_gateway.dart';
import 'package:i_care/features/care/domain/repositories/access_repository.dart';

/// [AccessRepository] over Google's account picker, the [AccessGateway]
/// and the device's [CareRepositoryImpl] (to start its copy over).
class AccessRepositoryImpl implements AccessRepository {
  AccessRepositoryImpl({
    required this._google,
    required this._gateway,
    required this._care,
  });

  final GoogleAccountSource _google;
  final AccessGateway _gateway;
  final CareRepositoryImpl _care;

  @override
  Future<Result<String?>> protectedWith() => guard(_gateway.protectedWith);

  @override
  Future<Result<String?>> protect() => guard(() async {
    final credential = await _google.pick();
    if (credential == null) return null;
    return await _gateway.protect(credential);
  });

  @override
  Future<Result<String?>> recover() async {
    final recovered = await guard(() async {
      final credential = await _google.pick();
      if (credential == null) return null;
      return await _gateway.recover(credential);
    });
    if (recovered case Ok(value: String())) {
      if (await _care.restart() case Err(:final failure)) return Err(failure);
    }
    return recovered;
  }
}
