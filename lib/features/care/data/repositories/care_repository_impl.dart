import 'dart:async';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/repositories/care_repository.dart';

/// Local-first [CareRepository]: writes go to the [EventStore] and are
/// pushed through the [SyncGateway] when possible; the server's events
/// are merged in as they arrive. Call [start] once and [dispose] at the
/// end.
class CareRepositoryImpl implements CareRepository {
  CareRepositoryImpl({
    required this._events,
    required this._syncState,
    required this._gateway,
    required this._clock,
  });

  final EventStore _events;
  final SyncStateStore _syncState;
  final SyncGateway _gateway;
  final DateTime Function() _clock;

  final _statusChanges = StreamController<SyncStatus>.broadcast();
  StreamSubscription<SyncBatch>? _subscription;
  var _isConnected = true;

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

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _applying;
    await _pushing;
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
  Stream<SyncStatus> watchSyncStatus() async* {
    yield _status();
    yield* _statusChanges.stream;
  }

  Future<void> _onBatch(SyncBatch batch) async {
    try {
      await _events.merge(batch.events);
      await _syncState.save(cursor: batch.cursor, lastSyncedAt: _clock());
      _isConnected = true;
      _emitStatus();
      await _push();
    } on AppException catch (error, stackTrace) {
      AppLogger.error('Could not apply synced events', error, stackTrace);
    }
  }

  void _onWatchError(Object error, StackTrace stackTrace) {
    if (error is! NoConnectionException) {
      AppLogger.error('Sync stream failed', error, stackTrace);
    }
    _isConnected = false;
    _emitStatus();
  }

  Future<void> _push() => _pushing = _pushing.then((_) => _pushPending());

  Future<void> _pushPending() async {
    try {
      final pending = _events.readPending();
      if (pending.isEmpty) return;
      final stored = await _gateway.push(pending);
      await _events.merge(stored);
      await _syncState.save(lastSyncedAt: _clock());
      _isConnected = true;
    } on NoConnectionException {
      _isConnected = false;
    } on AppException catch (error, stackTrace) {
      AppLogger.error('Could not push events', error, stackTrace);
    }
    _emitStatus();
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
        isConnected: _isConnected,
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
