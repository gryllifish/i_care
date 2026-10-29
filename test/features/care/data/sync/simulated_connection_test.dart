import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';

import '../../helpers/hive_boxes.dart';
import 'sync_gateway_contract.dart';

void main() {
  final openBox = useTemporaryHive();

  group('SimulatedConnection', () {
    runSyncGatewayContract(() async {
      final server = SimulatedServer(
        await openBox(SimulatedServer.boxName),
        clock: DateTime.now,
      );
      final device = SimulatedConnection(server);
      return (
        device: device,
        other: SimulatedConnection(server),
        setDeviceOnline: ({required bool online}) => device.isOnline = online,
      );
    });
  });
}
