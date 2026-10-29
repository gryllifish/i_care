import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'id_provider.g.dart';

/// Generates ids that are unique across devices without asking a server;
/// tests override it with predictable ids.
@Riverpod(keepAlive: true)
String Function() newId(Ref ref) => const Uuid().v4;
