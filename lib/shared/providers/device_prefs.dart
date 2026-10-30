import 'package:hive_ce/hive.dart';
import 'package:i_care/core/utils/hive_guard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_prefs.g.dart';

/// Small settings that belong to one phone, not to the circle: never
/// synced, so each caregiver keeps their own.
abstract interface class DevicePrefs {
  String? read(String key);
  Future<void> write(String key, String? value);
}

/// Keys of the preferences stored on each device.
abstract final class PrefKeys {
  static const caregiverId = 'caregiver_id';
  static const language = 'language';
  static const welcomeSeen = 'welcome_seen';
}

/// Preferences in a Hive box, so they survive restarts.
class HiveDevicePrefs implements DevicePrefs {
  const HiveDevicePrefs(this._box);

  final Box<String> _box;

  static String boxName(String deviceId) => 'prefs_$deviceId';

  @override
  String? read(String key) => hiveGuard('Preferences', () => _box.get(key));

  @override
  Future<void> write(String key, String? value) => hiveGuard(
    'Preferences',
    () => value == null ? _box.delete(key) : _box.put(key, value),
  );
}

/// Preferences kept in memory: the default, and what tests start from.
class MemoryDevicePrefs implements DevicePrefs {
  MemoryDevicePrefs([Map<String, String>? values]) : _values = {...?values};

  final Map<String, String> _values;

  @override
  String? read(String key) => _values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }
}

/// This device's preferences; `bootstrap` overrides it with Hive.
@Riverpod(keepAlive: true)
DevicePrefs devicePrefs(Ref ref) => MemoryDevicePrefs();
