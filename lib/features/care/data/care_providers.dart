import 'package:hive_ce/hive.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/repositories/care_repository_impl.dart';
import 'package:i_care/features/care/data/repositories/membership_repository_impl.dart';
import 'package:i_care/features/care/data/sync/membership_gateway.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/repositories/care_repository.dart';
import 'package:i_care/features/care/domain/repositories/membership_repository.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'care_providers.g.dart';

// Each simulated device runs in its own ProviderContainer. Boxes are
// opened asynchronously, so `bootstrap` opens them per device and
// overrides these providers; tests override them with their own.

/// This device's event log box.
@Riverpod(keepAlive: true)
Box<String> eventBox(Ref ref) =>
    throw UnimplementedError('Override eventBoxProvider at startup');

/// This device's box of events the server refused.
@Riverpod(keepAlive: true)
Box<String> rejectedBox(Ref ref) =>
    throw UnimplementedError('Override rejectedBoxProvider at startup');

/// How the server knows this device. Each simulated phone overrides it.
@Riverpod(keepAlive: true)
String deviceId(Ref ref) =>
    throw UnimplementedError('Override deviceIdProvider at startup');

/// This device's sync state box.
@Riverpod(keepAlive: true)
Box<String> syncStateBox(Ref ref) =>
    throw UnimplementedError('Override syncStateBoxProvider at startup');

/// The server every device shares; the same instance is given to every
/// device container.
@Riverpod(keepAlive: true)
SimulatedServer simulatedServer(Ref ref) =>
    throw UnimplementedError('Override simulatedServerProvider at startup');

/// Delay of every simulated network trip.
const simulatedLatency = Duration(milliseconds: 600);

/// This device's connection, exposed with its concrete type so the demo
/// controls can switch the network off.
@Riverpod(keepAlive: true)
SimulatedConnection simulatedConnection(Ref ref) {
  final connection = SimulatedConnection(
    ref.watch(simulatedServerProvider),
    deviceId: ref.watch(deviceIdProvider),
    latency: simulatedLatency,
  );
  ref.onDispose(connection.dispose);
  return connection;
}

@Riverpod(keepAlive: true)
SyncGateway syncGateway(Ref ref) => ref.watch(simulatedConnectionProvider);

/// The repository with its sync controls, for the demo's reset.
@Riverpod(keepAlive: true)
CareRepositoryImpl careRepositoryImpl(Ref ref) {
  final repository = CareRepositoryImpl(
    events: EventStore(ref.watch(eventBoxProvider)),
    rejected: RejectedStore(ref.watch(rejectedBoxProvider)),
    syncState: SyncStateStore(ref.watch(syncStateBoxProvider)),
    gateway: ref.watch(syncGatewayProvider),
    clock: ref.watch(clockProvider),
  )..start();
  ref.onDispose(repository.dispose);
  return repository;
}

@Riverpod(keepAlive: true)
CareRepository careRepository(Ref ref) => ref.watch(careRepositoryImplProvider);

@Riverpod(keepAlive: true)
MembershipGateway membershipGateway(Ref ref) =>
    ref.watch(simulatedConnectionProvider);

@Riverpod(keepAlive: true)
MembershipRepository membershipRepository(Ref ref) => MembershipRepositoryImpl(
  care: ref.watch(careRepositoryImplProvider),
  gateway: ref.watch(membershipGatewayProvider),
  meta: (memberId) => EventMeta(
    id: ref.read(newIdProvider)(),
    caregiverId: memberId,
    occurredAt: ref.read(clockProvider)(),
  ),
);
