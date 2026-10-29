import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'care_recorder.g.dart';

/// Appends events as the current caregiver, now. Every action in the app
/// goes through it, so ids, authorship and time are set in one place.
class CareRecorder {
  const CareRecorder(this._ref);

  final Ref _ref;

  /// Metadata for a new event by the current caregiver at this moment.
  EventMeta meta() => EventMeta(
    id: _ref.read(newIdProvider)(),
    caregiverId: _ref.read(currentCaregiverProvider).id,
    occurredAt: _ref.read(clockProvider)(),
  );

  /// Appends [event] and returns it, or the failure to store it.
  Future<Result<T>> record<T extends CareEvent>(T event) async =>
      switch (await _ref.read(careRepositoryProvider).record(event)) {
        Ok() => Ok(event),
        Err(:final failure) => Err(failure),
      };

  /// Appends [events] in order, stopping at the first failure.
  Future<Result<void>> recordAll(List<CareEvent> events) async {
    for (final event in events) {
      if (await record(event) case Err(:final failure)) return Err(failure);
    }
    return const Ok(null);
  }
}

@Riverpod(keepAlive: true)
CareRecorder careRecorder(Ref ref) => CareRecorder(ref);
