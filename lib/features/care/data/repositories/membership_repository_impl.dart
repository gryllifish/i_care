import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/repositories/care_repository_impl.dart';
import 'package:i_care/features/care/data/sync/membership_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/repositories/membership_repository.dart';

/// [MembershipRepository] over the device's [CareRepositoryImpl] (for
/// what is pending and the local copy) and the [MembershipGateway].
class MembershipRepositoryImpl implements MembershipRepository {
  MembershipRepositoryImpl({
    required this._care,
    required this._gateway,
    required this._meta,
  });

  final CareRepositoryImpl _care;
  final MembershipGateway _gateway;

  /// Metadata for an event written now by the given member.
  final EventMeta Function(String memberId) _meta;

  @override
  Future<Result<InviteCode>> issueCode(String memberId) async {
    if (await _care.flush() case Err(:final failure)) return Err(failure);
    return guard(() => _gateway.issueCode(memberId));
  }

  @override
  Future<Result<String>> createCircle({
    required String creatorName,
    required String recipientName,
  }) => _startingOver(
    () => _gateway.createCircle(
      creatorName: creatorName,
      recipientName: recipientName,
    ),
  );

  @override
  Future<Result<String>> join(String code) =>
      _startingOver(() => _gateway.join(code));

  /// Runs [request], then starts this device's copy of the log over.
  Future<Result<String>> _startingOver(
    Future<String> Function() request,
  ) async {
    final joined = await guard(request);
    if (joined case Ok()) {
      if (await _care.restart() case Err(:final failure)) return Err(failure);
    }
    return joined;
  }

  @override
  Future<Result<void>> leave(String memberId) async {
    // Everything pending goes first: offline, nobody leaves.
    if (await _care.flush() case Err(:final failure)) return Err(failure);
    if (await _care.record(
          CareEvent.memberLeft(meta: _meta(memberId), memberId: memberId),
        )
        case Err(:final failure)) {
      return Err(failure);
    }
    if (await _care.flush() case Err(:final failure)) return Err(failure);
    return forget();
  }

  @override
  Future<Result<void>> forget() => _care.restart();
}
