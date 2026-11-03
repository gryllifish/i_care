import 'dart:async';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/repositories/care_repository.dart';

/// Local-first [CareRepository]: writes go to the [EventStore] and are
/// pushed through the [SyncGateway] when possible; the server's events
/// are merged in as they arrive. Call [start] once and [dispose] at the
/// end.
class CareRepositoryImpl implements CareRepository {
  CareRepositoryImpl({
    required this._events,
    required this._rejected,
    required this._syncState,
    required this._gateway,
    required this._clock,
  });

  final EventStore _events;
  final RejectedStore _rejected;
  final SyncStateStore _syncState;
  final SyncGateway _gateway;
  final DateTime Function() _clock;

  final _statusChanges = StreamController<SyncStatus>.broadcast();
  StreamSubscription<SyncBatch>? _subscription;
  var _isConnected = true;
  var _isMember = true;

  /// Pushes run one after another, so an event is never sent twice at
  /// once.
  var _pushing = Future<void>.value();

  /// Batches are applied in arrival order, so the saved cursor never goes
  /// back.
  var _applying = Future<void>.value();

  /// Starts receiving the server's events and pushes anything pending.
  void start() {
    _subscription = _gateway
        .watch(cursor: _syncState.cursor)
        .listen(
          (batch) => _applying = _applying.then((_) => _onBatch(batch)),
          onError: _onWatchError,
        );
    unawaited(_push());
  }

  /// Stops syncing and waits for work in flight, so the stores can be
  /// cleared safely; [start] resumes from whatever cursor is stored then.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _applying;
    await _pushing;
  }

  Future<void> dispose() async {
    await stop();
    await _statusChanges.close();
  }

  @override
  Stream<List<CareEvent>> watchEvents() async* {
    yield _readAll();
    await for (final _ in _events.changes) {
      yield _readAll();
    }
  }

  @override
  Future<Result<void>> record(CareEvent event) => guard(() async {
    await _events.merge([event]);
    _emitStatus();
    unawaited(_push());
  });

  @override
  Future<Result<void>> syncNow() => guard(() async {
    await stop();
    start();
    await _pushing;
  });

  @override
  Stream<SyncStatus> watchSyncStatus() async* {
    yield _status();
    yield* _statusChanges.stream;
  }

  @override
  Stream<List<RejectedEvent>> watchRejected() async* {
    yield _readRejected();
    await for (final _ in _rejected.changes) {
      yield _readRejected();
    }
  }

  @override
  Future<Result<void>> dismissRejected(String eventId) => guard(() async {
    await _rejected.remove(eventId);
    _emitStatus();
  });

  Future<void> _onBatch(SyncBatch batch) async {
    try {
      await _events.merge(batch.events);
      if (batch.unreadable.isNotEmpty) {
        await _events.keepUnreadable(batch.unreadable);
        AppLogger.warning(
          '${batch.unreadable.length} event(s) need a newer app version',
        );
      }
      await _syncState.save(cursor: batch.cursor, lastSyncedAt: _clock());
      _isConnected = true;
      _emitStatus();
      await _push();
    } on AppException catch (error, stackTrace) {
      AppLogger.error('Could not apply synced events', error, stackTrace);
    }
  }

  void _onWatchError(Object error, StackTrace stackTrace) {
    if (error is NotMemberException) {
      // Send what is still here too: the server keeps a former member's
      // facts, flagged, and a dose given must not be lost. The app waits
      // for nothing pending before clearing this device.
      _isMember = false;
      _emitStatus();
      unawaited(_push());
      return;
    }
    if (error is! NoConnectionException) {
      AppLogger.error('Sync stream failed', error, stackTrace);
    }
    _isConnected = false;
    _emitStatus();
  }

  /// Sends what is pending and waits. Fails when it could not all be sent,
  /// for instance offline: leaving a circle must not lose records.
  Future<Result<void>> flush() => guard(() async {
    await _push();
    if (_events.readPending().isNotEmpty) {
      throw const NoConnectionException('Records still to send');
    }
  });

  /// Clears this device's copy of the log and syncs again from the start:
  /// after joining a circle, leaving one, or a role change that changes
  /// what this device may read. What was never sent stays, to be sent:
  /// a record is never lost to a restart.
  Future<Result<void>> restart() => guard(() async {
    await stop();
    final unsent = _events.readPending();
    await _events.clear();
    await _events.merge(unsent);
    await _rejected.clear();
    await _syncState.clear();
    _isMember = true;
    _isConnected = true;
    start();
  });

  Future<void> _push() => _pushing = _pushing.then((_) => _pushPending());

  Future<void> _pushPending() async {
    try {
      final pending = _events.readPending();
      if (pending.isEmpty) return;
      final result = await _gateway.push(pending);
      await _events.merge(result.stored);
      if (result.rejected.isNotEmpty) {
        // Kept apart first, then dropped from the log: never lost.
        await _rejected.add(result.rejected);
        await _events.remove([
          for (final rejected in result.rejected) rejected.event.meta.id,
        ]);
        AppLogger.warning(
          '${result.rejected.length} event(s) refused by the server',
        );
      }
      await _syncState.save(lastSyncedAt: _clock());
      _isConnected = true;
    } on NoConnectionException {
      _isConnected = false;
    } on AppException catch (error, stackTrace) {
      AppLogger.error('Could not push events', error, stackTrace);
    }
    _emitStatus();
  }

  List<RejectedEvent> _readRejected() {
    try {
      return _rejected.readAll();
    } on AppException catch (error) {
      throw error.toFailure();
    }
  }

  List<CareEvent> _readAll() {
    try {
      return _events.readAll();
    } on AppException catch (error) {
      throw error.toFailure();
    }
  }

  SyncStatus _status() {
    try {
      return SyncStatus(
        lastSyncedAt: _syncState.lastSyncedAt,
        pendingCount: _events.readPending().length,
        rejectedCount: _rejected.readAll().length,
        isConnected: _isConnected,
        isMember: _isMember,
      );
    } on AppException catch (error, stackTrace) {
      AppLogger.error('Could not read sync status', error, stackTrace);
      return SyncStatus(isConnected: _isConnected);
    }
  }

  void _emitStatus() {
    if (!_statusChanges.isClosed) _statusChanges.add(_status());
  }
}
