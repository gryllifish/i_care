import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// Points Hive at a fresh temporary directory for each test and returns a
/// function that opens boxes in it.
Future<Box<String>> Function(String name) useTemporaryHive() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('i_care_hive_');
    Hive.init(directory.path);
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  return Hive.openBox<String>;
}
