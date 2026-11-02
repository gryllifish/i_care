import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reason_actions.g.dart';

/// The circle's own reasons for not giving a dose or doing a task, and
/// which reasons are offered. Callers check a new label with
/// `isNewReasonLabel` first.
@Riverpod(keepAlive: true)
class ReasonActions extends _$ReasonActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);

  Future<Result<void>> add(String label) => _recorder.record(
    CareEvent.skipReasonAdded(
      meta: _recorder.meta(),
      reasonId: 'custom-${ref.read(newIdProvider)()}',
      label: label.trim(),
    ),
  );

  Future<Result<void>> hide(String reasonId) => _recorder.record(
    CareEvent.skipReasonHidden(meta: _recorder.meta(), reasonId: reasonId),
  );

  Future<Result<void>> show(String reasonId) => _recorder.record(
    CareEvent.skipReasonShown(meta: _recorder.meta(), reasonId: reasonId),
  );
}
