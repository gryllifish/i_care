import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipient_profile.freezed.dart';

/// Someone to call: a doctor or a relative.
@freezed
abstract class CareContact with _$CareContact {
  const factory CareContact({
    required String name,

    /// Specialty for doctors, relationship for relatives.
    @Default('') String role,
    @Default('') String phone,
  }) = _CareContact;
}

/// What the emergency card shows about the person cared for, besides
/// their medications (which come from the log).
@freezed
abstract class RecipientProfile with _$RecipientProfile {
  const factory RecipientProfile({
    required String name,
    DateTime? birthDate,

    /// Free text, one per line, shown first and in red.
    @Default('') String allergies,
    @Default('') String conditions,
    @Default(<CareContact>[]) List<CareContact> doctors,
    @Default(<CareContact>[]) List<CareContact> contacts,
    @Default('') String notes,
  }) = _RecipientProfile;

  const RecipientProfile._();

  /// Whole years of age on [today], or null without a birth date.
  int? ageOn(DateTime today) {
    final birth = birthDate;
    if (birth == null) return null;
    final hadBirthday =
        today.month > birth.month ||
        (today.month == birth.month && today.day >= birth.day);
    return today.year - birth.year - (hadBirthday ? 0 : 1);
  }
}
