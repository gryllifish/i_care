import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sync/access_gateway.dart';
import 'package:i_care/features/care/data/sync/membership_gateway.dart';
import 'package:i_care/features/care/data/sync/push_token_gateway.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// This device's link to the Supabase backend (`docs/backend.md`,
/// "Supabase"): the functions in `supabase/migrations/`, called as the
/// device's anonymous user, signed in on first use, or as the Google
/// account protecting its access (`docs/roles.md`, recoverable access).
/// Supabase types never leave this class.
class SupabaseConnection
    implements SyncGateway, MembershipGateway, PushTokenGateway, AccessGateway {
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

  @override
  Future<void> deleteCircle() => _call('delete_circle');

  @override
  Future<String?> protectedWith() async => switch (_client.auth.currentUser) {
    final User user when !user.isAnonymous => user.email,
    _ => null,
  };

  @override
  Future<String> protect(GoogleCredential credential) async {
    try {
      await _auth(
        () => _client.auth.linkIdentityWithIdToken(
          provider: OAuthProvider.google,
          idToken: credential.idToken,
          accessToken: credential.accessToken,
        ),
      );
    } on ServerException catch (error) {
      if (error.cause case AuthException(:final code)
          when code == ErrorCode.identityAlreadyExists.code) {
        throw AccountInUseException('Account in use', cause: error);
      }
      rethrow;
    }
    // Linking may start a new session: this phone's, so nobody is told.
    await _call('confirm_session');
    return _client.auth.currentUser?.email ?? credential.email;
  }

  @override
  Future<String> recover(GoogleCredential credential) async {
    await _auth(
      () => _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: credential.idToken,
        accessToken: credential.accessToken,
      ),
    );
    // Confirming is what tells the circle; nothing is read before it.
    await _call('confirm_session');
    if (await _call('current_member') case final String memberId) {
      // The lost phone's sessions end, and the server refuses them at once.
      await _auth(() => _client.auth.signOut(scope: SignOutScope.others));
      return memberId;
    }
    // Signing in created an account linked to no one: it goes.
    await _call('discard_unbound_user');
    await _signOutHere();
    throw const NoAccessException('No access with this account');
  }

  @override
  Future<void> registerPushToken({
    required String token,
    required String platform,
    required String language,
  }) => _call('register_push_token', {
    'p_token': token,
    'p_platform': platform,
    'p_language': language,
  });

  @override
  Future<void> unregisterPushToken() => _call('unregister_push_token');

  /// Calls the backend function [name] as this device.
  ///
  /// A session the server no longer accepts is settled once, then the
  /// call is repeated: an ended one (signed out from another phone, or
  /// its account deleted with the circle) makes this device start over
  /// as a new anonymous one, which the server then tells whether it
  /// belongs to anyone; an unconfirmed one is confirmed.
  ///
  /// Throws [NoConnectionException], [RequestTimeoutException],
  /// [ServerException], [NotMemberException], [ForbiddenException] or
  /// [NotFoundException].
  Future<Object?> _call(String name, [Map<String, Object?>? params]) async {
    try {
      return await _rpc(name, params);
    } on _SessionRefused catch (refused) {
      if (refused.ended) {
        await _signOutHere();
      } else {
        await _rpc('confirm_session');
      }
    }
    try {
      return await _rpc(name, params);
    } on _SessionRefused catch (refused) {
      throw ServerException('$name refused the session again', cause: refused);
    }
  }

  /// Throws what [_call] does, and [_SessionRefused].
  Future<Object?> _rpc(String name, [Map<String, Object?>? params]) async {
    if (_client.auth.currentSession == null) {
      await _auth(_client.auth.signInAnonymously);
    }
    try {
      return await _client.rpc<Object?>(name, params: params).timeout(_timeout);
    } on TimeoutException catch (error) {
      throw RequestTimeoutException('$name timed out', cause: error);
    } on PostgrestException catch (error) {
      throw switch (error.message) {
        'session_ended' => const _SessionRefused(ended: true),
        'session_unconfirmed' => const _SessionRefused(ended: false),
        _ => _fromPostgrest(name, error),
      };
      // The HTTP client reports a lost network as its own exception type
      // (a socket error, or `ClientException` on the web), which the
      // Supabase packages do not export: any other exception here is the
      // transport's.
    } on Exception catch (error) {
      throw NoConnectionException('$name failed to connect', cause: error);
    }
  }

  /// Runs [request] against Supabase Auth.
  ///
  /// Throws [NoConnectionException], [RequestTimeoutException] or
  /// [ServerException] (with the [AuthException] as its cause).
  Future<T> _auth<T>(Future<T> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException catch (error) {
      throw RequestTimeoutException('Auth timed out', cause: error);
    } on AuthRetryableFetchException catch (error) {
      throw NoConnectionException('Could not reach Auth', cause: error);
    } on AuthException catch (error) {
      throw ServerException(
        'Auth refused: ${error.message}',
        statusCode: int.tryParse(error.statusCode ?? ''),
        cause: error,
      );
    } on Exception catch (error) {
      throw NoConnectionException('Auth failed to connect', cause: error);
    }
  }

  /// Forgets this device's session; the next call signs in anonymously.
  /// The session is gone here even when telling the server fails.
  Future<void> _signOutHere() async {
    try {
      await _auth(() => _client.auth.signOut());
    } on AppException catch (error, stackTrace) {
      AppLogger.warning('Signed out here only', error, stackTrace);
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

/// The server refused this device's session: [ended], or a protected
/// account's new session not yet confirmed.
class _SessionRefused implements Exception {
  const _SessionRefused({required this.ended});

  final bool ended;
}
