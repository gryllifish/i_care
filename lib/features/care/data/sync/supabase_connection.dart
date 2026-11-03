import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sync/membership_gateway.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// This device's link to the Supabase backend (`docs/backend.md`,
/// "Supabase"): the functions in `supabase/migrations/`, called as the
/// device's anonymous user, signed in on first use. Supabase types never
/// leave this class.
class SupabaseConnection implements SyncGateway, MembershipGateway {
  SupabaseConnection(
    this._client, {
    this._pollInterval = const Duration(seconds: 30),
    this._timeout = const Duration(seconds: 15),
    this._pageSize = 500,
    this._pushBatchSize = 100,
  });

  final SupabaseClient _client;

  /// How often [watch] reads even without a Realtime ping: Realtime may
  /// drop messages, and a failed read is how an idle device learns it
  /// is offline.
  final Duration _pollInterval;
  final Duration _timeout;
  final int _pageSize;
  final int _pushBatchSize;

  @override
  Future<PushResult> push(List<CareEvent> events) async {
    final stored = <CareEvent>[];
    final rejected = <RejectedEvent>[];
    // Batches keep each request small after a long time offline.
    for (var start = 0; start < events.length; start += _pushBatchSize) {
      final batch = events.sublist(
        start,
        min(start + _pushBatchSize, events.length),
      );
      final byId = {for (final event in batch) event.meta.id: event};
      final result = await _call('push_events', {
        'p_events': [for (final event in batch) CareEventCodec.encode(event)],
      });
      if (result case {
        'stored': final List<Object?> storedJson,
        'rejected': final List<Object?> rejectedJson,
      }) {
        stored.addAll([for (final json in storedJson) _decode(json)]);
        for (final json in rejectedJson) {
          if (json case {'id': final String id, 'reason': final String why}) {
            if (byId[id] case final event?) {
              rejected.add(RejectedEvent(event: event, reason: _reason(why)));
            }
          }
        }
      } else {
        throw const ParsingException('Unexpected push result');
      }
    }
    return (stored: stored, rejected: rejected);
  }

  @override
  Stream<SyncBatch> watch({String? cursor}) {
    var position = cursor;
    // Whether the last read worked; the first one, and the first after a
    // failure, always report, so the device knows it is connected.
    var healthy = false;
    Timer? poll;
    RealtimeChannel? channel;
    late final StreamController<SyncBatch> controller;
    late final void Function() scheduleRead;
    var reading = Future<void>.value();

    Future<void> listenForPings() async {
      final circle = await _call('current_circle');
      if (circle is! String || controller.isClosed) return;
      channel = _client
          .channel(
            'circle:$circle',
            opts: const RealtimeChannelConfig(private: true),
          )
          .onBroadcast(event: 'appended', callback: (_) => scheduleRead())
          .subscribe((status, error) {
            // Polling still catches up; Realtime only makes it prompt.
            if (error != null) {
              AppLogger.warning('Realtime channel $status: $error');
            }
          });
    }

    Future<void> read() async {
      try {
        final events = <CareEvent>[];
        final unreadable = <String>[];
        var next = position;
        while (true) {
          final page = await _call('events_after', {
            'p_cursor': next,
            'p_limit': _pageSize,
          });
          if (page case {
            'events': final List<Object?> pageEvents,
            'cursor': final String pageCursor,
          }) {
            for (final json in pageEvents) {
              if (json is! Map<String, Object?>) {
                throw const ParsingException('Event is not a JSON object');
              }
              switch (CareEventCodec.tryDecode(json)) {
                case final event?:
                  events.add(event);
                case null:
                  unreadable.add(jsonEncode(json));
              }
            }
            next = pageCursor;
            if (pageEvents.length < _pageSize) break;
          } else {
            throw const ParsingException('Unexpected events page');
          }
        }
        if (controller.isClosed) return;
        if (healthy && next == position) return;
        position = next;
        healthy = true;
        controller.add((events: events, unreadable: unreadable, cursor: next));
        if (channel == null) await listenForPings();
      } on AppException catch (error) {
        healthy = false;
        if (!controller.isClosed) controller.addError(error);
      }
    }

    // Reads run one at a time, so batches never overlap or reorder.
    scheduleRead = () => reading = reading.then((_) => read());

    controller = StreamController<SyncBatch>(
      onListen: () {
        poll = Timer.periodic(_pollInterval, (_) => scheduleRead());
        scheduleRead();
      },
      onCancel: () async {
        poll?.cancel();
        if (channel case final open?) await _client.removeChannel(open);
      },
    );
    return controller.stream;
  }

  @override
  Future<InviteCode> issueCode(String memberId) async {
    final result = await _call('issue_code', {'p_member_id': memberId});
    if (result case {
      'code': final String code,
      'expires_at': final String expiresAt,
    }) {
      if (DateTime.tryParse(expiresAt) case final DateTime at) {
        return InviteCode(code: _display(code), expiresAt: at.toLocal());
      }
    }
    throw const ParsingException('Unexpected invitation code');
  }

  @override
  Future<String> createCircle({
    required String creatorName,
    required String recipientName,
  }) async {
    final memberId = await _call('create_circle', {
      'p_creator_name': creatorName,
      'p_recipient_name': recipientName,
    });
    if (memberId is String) return memberId;
    throw const ParsingException('Unexpected member id');
  }

  @override
  Future<String> join(String code) async {
    final result = await _call('join_circle', {'p_code': code});
    return switch (result) {
      {'member_id': final String memberId} => memberId,
      {'error': final String problem} => throw InvalidCodeException(
        switch (problem) {
          'used' => CodeProblem.used,
          'expired' => CodeProblem.expired,
          'locked' => CodeProblem.locked,
          _ => CodeProblem.unknown,
        },
        'Code refused: $problem',
      ),
      _ => throw const ParsingException('Unexpected join result'),
    };
  }

  /// Calls the backend function [name] as this device.
  ///
  /// Throws [NoConnectionException], [RequestTimeoutException],
  /// [ServerException], [NotMemberException], [ForbiddenException] or
  /// [NotFoundException].
  Future<Object?> _call(String name, [Map<String, Object?>? params]) async {
    try {
      if (_client.auth.currentSession == null) {
        await _client.auth.signInAnonymously().timeout(_timeout);
      }
      return await _client.rpc<Object?>(name, params: params).timeout(_timeout);
    } on TimeoutException catch (error) {
      throw RequestTimeoutException('$name timed out', cause: error);
    } on PostgrestException catch (error) {
      throw _fromPostgrest(name, error);
    } on AuthRetryableFetchException catch (error) {
      throw NoConnectionException('Could not sign in', cause: error);
    } on AuthException catch (error) {
      throw ServerException(
        'Sign-in refused: ${error.message}',
        statusCode: int.tryParse(error.statusCode ?? ''),
        cause: error,
      );
      // The HTTP client reports a lost network as its own exception type
      // (a socket error, or `ClientException` on the web), which the
      // Supabase packages do not export: any other exception here is the
      // transport's.
    } on Exception catch (error) {
      throw NoConnectionException('$name failed to connect', cause: error);
    }
  }

  static AppException _fromPostgrest(String name, PostgrestException error) {
    // `code` is an HTTP status when the response was not PostgREST's own
    // error (a gateway, a paused project), else a SQLSTATE such as 42501.
    final status = switch (int.tryParse(error.code ?? '')) {
      final int code when code >= 400 && code < 600 => code,
      _ => null,
    };
    return switch (error.message) {
      'not_member' => NotMemberException(name, cause: error),
      'forbidden' => ForbiddenException(name, cause: error),
      'not_found' => NotFoundException(name, cause: error),
      _ => ServerException(
        '$name failed: ${error.message}',
        statusCode: status,
        cause: error,
      ),
    };
  }

  static CareEvent _decode(Object? json) => switch (json) {
    final Map<String, Object?> map => CareEventCodec.decode(map),
    _ => throw const ParsingException('Event is not a JSON object'),
  };

  static RejectionReason _reason(String reason) => switch (reason) {
    'wrong_author' => RejectionReason.wrongAuthor,
    'not_member' => RejectionReason.notMember,
    'last_admin' => RejectionReason.lastAdmin,
    _ => RejectionReason.notAllowed,
  };

  /// "K7P4QM" as "K7P-4QM": easier to read aloud and type.
  static String _display(String code) =>
      '${code.substring(0, code.length ~/ 2)}-'
      '${code.substring(code.length ~/ 2)}';
}
