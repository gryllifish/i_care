import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_actions.g.dart';

/// Whether this build offers protecting access with a Google account
/// (`docs/roles.md`, recoverable access): the beta on Android.
@riverpod
bool accessOffered(Ref ref) => ref.watch(accessRepositoryProvider) != null;

/// The email of the Google account protecting this phone's access; null
/// when none does, or where it is not offered.
@Riverpod(keepAlive: true)
class ProtectedAccess extends _$ProtectedAccess {
  @override
  Future<String?> build() async {
    final repository = ref.watch(accessRepositoryProvider);
    // Whoever joins or leaves on this phone has an access of their own.
    ref.watch(deviceMembershipProvider);
    if (repository == null) return null;
    switch (await repository.protectedWith()) {
      case Ok(:final value):
        return value;
      case Err(:final failure):
        AppLogger.warning('Protected access not read', failure);
        return null;
    }
  }

  /// Asks for a Google account and protects this phone's access with it.
  /// Closing Google's picker changes nothing and is no failure.
  Future<Result<void>> protect() async {
    final repository = ref.read(accessRepositoryProvider);
    if (repository == null) return const Ok(null);
    switch (await repository.protect()) {
      case Ok(:final value):
        if (value != null) state = AsyncData(value);
        return const Ok(null);
      case Err(:final failure):
        return Err(failure);
    }
  }

  /// Asks for a Google account and makes this phone the member whose
  /// access it protects. Closing Google's picker changes nothing.
  Future<Result<void>> recover() async {
    final repository = ref.read(accessRepositoryProvider);
    if (repository == null) return const Ok(null);
    switch (await repository.recover()) {
      case Ok(value: final String memberId):
        await ref.read(deviceMembershipProvider.notifier).joined(memberId);
        return const Ok(null);
      case Ok():
        return const Ok(null);
      case Err(:final failure):
        return Err(failure);
    }
  }
}

/// Whether the circle depends on one admin: if they lose their phone,
/// nobody else can issue codes (`docs/roles.md`). Admins only invited do
/// not count, since they have no phone yet.
@riverpod
bool hasSingleAdmin(Ref ref) =>
    ref
        .watch(membersProvider)
        .where(
          (member) =>
              member.role == MemberRole.admin &&
              member.status == MemberStatus.active,
        )
        .length ==
    1;
