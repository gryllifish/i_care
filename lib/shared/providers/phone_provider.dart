import 'package:flutter/services.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'phone_provider.g.dart';

/// Opens the phone app to call [number]; resolves to whether it could.
/// Tests override it, so no test ever dials.
typedef PhoneCaller = Future<bool> Function(String number);

@Riverpod(keepAlive: true)
PhoneCaller phoneCaller(Ref ref) => (number) async {
  final uri = Uri(
    scheme: 'tel',
    path: number.replaceAll(RegExp('[^0-9+]'), ''),
  );
  try {
    return await launchUrl(uri);
  } on PlatformException catch (error, stackTrace) {
    AppLogger.warning('Could not open the phone app', error, stackTrace);
    return false;
  }
};
