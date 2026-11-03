import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_actions.g.dart';

/// Leaving notes for the circle ("te dejo dicho").
@Riverpod(keepAlive: true)
class NoteActions extends _$NoteActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);

  /// Leaves [text] for the circle. Callers offer it only when [text] is
  /// not blank.
  Future<Result<void>> leave(String text) => _recorder.record(
    CareEvent.careNoteAdded(meta: _recorder.meta(), text: text.trim()),
  );
}
