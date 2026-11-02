import 'package:flutter/services.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'link_opener.g.dart';

/// Opens [url] outside the app (a browser, or the app that handles it);
/// resolves to whether it could. Tests override it, so no test opens one.
typedef LinkOpener = Future<bool> Function(String url);

@Riverpod(keepAlive: true)
LinkOpener linkOpener(Ref ref) => (url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on PlatformException catch (error, stackTrace) {
    AppLogger.warning('Could not open a link', error, stackTrace);
    return false;
  }
};
