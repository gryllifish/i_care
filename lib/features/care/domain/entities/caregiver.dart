import 'package:freezed_annotation/freezed_annotation.dart';

part 'caregiver.freezed.dart';

/// A member of the care circle who records what they do.
@freezed
abstract class Caregiver with _$Caregiver {
  const factory Caregiver({
    required String id,
    required String name,

    /// Index into the avatar palette, stable across devices.
    required int colorIndex,
  }) = _Caregiver;
}
