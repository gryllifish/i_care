import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
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
        await openBox(SimulatedServer.devicesBoxName),
        clock: DateTime.now,
      );
      await server.seed([
        for (final event in SampleCircle.memberEvents(DateTime(2025)))
          CareEventCodec.encodeString(event),
      ]);
      for (final member in SampleCircle.members) {
        await server.bind('phone-${member.id}', member.id);
      }
      SimulatedConnection connect(String memberId) =>
          SimulatedConnection(server, deviceId: 'phone-$memberId');

      final device = connect('ana');
      return (
        device: device,
        other: connect('martin'),
        helper: connect('rosa'),
        setDeviceOnline: ({required bool online}) => device.isOnline = online,
      );
    });
  });
}
