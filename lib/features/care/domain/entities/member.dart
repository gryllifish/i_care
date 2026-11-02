import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';

/// What a member may do and see (`docs/roles.md`).
enum MemberRole {
  /// Organizes the care, including who belongs to the circle.
  admin,

  /// Family or nurses who care every day.
  caregiver,

  /// Occasional help: today's care only.
  helper,

  /// Follows along without changing anything.
  viewer,
}

enum MemberStatus {
  /// Invited; no device has joined as them yet.
  invited,
  active,

  /// Removed from the circle; their records stay in the log.
  removed,
}

/// A person in the care circle, as projected from the log.
@freezed
abstract class Member with _$Member {
  const factory Member({
    required String id,
    required String name,

    /// Index into the avatar palette, stable across devices.
    required int colorIndex,
    required MemberRole role,
    @Default(MemberStatus.active) MemberStatus status,

    /// Number of role changes and removals applied, for their
    /// `baseVersion`.
    @Default(0) int version,
  }) = _Member;

  const Member._();

  bool get isRemoved => status == MemberStatus.removed;
}
