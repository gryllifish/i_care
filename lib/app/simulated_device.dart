import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/features/care/domain/entities/member.dart';

/// One caregiver's phone in the demo: its own provider container, so its
/// storage, router and state are separate from the other phone's. The
/// phones share only the simulated server.
class SimulatedDevice {
  const SimulatedDevice({required this.owner, required this.container});

  final Member owner;
  final ProviderContainer container;
}
