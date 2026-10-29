import 'dart:async';

import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'now_provider.g.dart';

/// How often [Now] moves forward, so statuses like "late" update on
/// their own.
const nowTick = Duration(seconds: 30);

/// The current time, refreshed every [nowTick]. Widgets and derived state
/// watch this; actions read `clockProvider` for the exact moment.
@Riverpod(keepAlive: true)
class Now extends _$Now {
  @override
  DateTime build() {
    final clock = ref.watch(clockProvider);
    final timer = Timer.periodic(nowTick, (_) => state = clock());
    ref.onDispose(timer.cancel);
    return clock();
  }
}
