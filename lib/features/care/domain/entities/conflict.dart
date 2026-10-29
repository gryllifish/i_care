import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

part 'conflict.freezed.dart';

/// Something caregivers did concurrently that needs a person to review.
/// Conflicts are never resolved automatically; a [ConflictAcknowledged]
/// event with the same [key] marks one as reviewed.
@freezed
sealed class Conflict with _$Conflict {
  /// Doses that look like one too many: two for the same scheduled time,
  /// or two closer than the minimum interval.
  const factory Conflict.dose({
    required String key,
    required String medicationId,
    required List<DoseGiven> doses,
  }) = DoseConflict;

  /// Two changes made on the same version of a medication.
  const factory Conflict.edit({
    required String key,
    required String medicationId,
    required List<CareEvent> changes,
  }) = EditConflict;
}
