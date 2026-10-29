import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medication_detail.freezed.dart';
part 'medication_detail.g.dart';

/// Everything the medication detail screen shows.
@freezed
abstract class MedicationDetail with _$MedicationDetail {
  const factory MedicationDetail({
    required Medication medication,
    StockLevel? stock,

    /// Latest doses given, newest first.
    @Default(<DoseGiven>[]) List<DoseGiven> recentDoses,

    /// Concurrent edits to this medication nobody has reviewed.
    @Default(<EditConflict>[]) List<EditConflict> conflicts,
  }) = _MedicationDetail;
}

/// How many recent doses the detail lists.
const recentDoseCount = 5;

/// The detail of [medicationId], archived or not; null when unknown.
MedicationDetail? buildMedicationDetail(CareLog log, String medicationId) {
  final medication = log.medication(medicationId);
  if (medication == null) return null;
  final doses = log.dosesGiven(medicationId)
    ..sort((a, b) => b.givenAt.compareTo(a.givenAt));
  return MedicationDetail(
    medication: medication,
    stock: log.stockOf(medicationId),
    recentDoses: doses.take(recentDoseCount).toList(),
    conflicts: [
      for (final conflict in log.conflicts.whereType<EditConflict>())
        if (conflict.medicationId == medicationId) conflict,
    ],
  );
}

@riverpod
AsyncValue<MedicationDetail?> medicationDetail(Ref ref, String medicationId) =>
    ref
        .watch(careLogProvider)
        .whenData((log) => buildMedicationDetail(log, medicationId));

/// Unreviewed concurrent edits, by medication id.
typedef ConflictsByMedication = Map<String, List<EditConflict>>;

/// Medications with concurrent edits nobody has reviewed, for the list.
@riverpod
AsyncValue<ConflictsByMedication> medicationConflicts(Ref ref) =>
    ref.watch(careLogProvider).whenData((log) {
      final byMedication = <String, List<EditConflict>>{};
      for (final conflict in log.conflicts.whereType<EditConflict>()) {
        (byMedication[conflict.medicationId] ??= []).add(conflict);
      }
      return byMedication;
    });
