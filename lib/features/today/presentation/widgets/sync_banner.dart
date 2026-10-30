import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// A pill saying how current this phone is with the others.
class SyncBanner extends ConsumerWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStatusProvider).value ?? const SyncStatus();
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();

    final (icon, color, background, text) = switch (status) {
      SyncStatus(isConnected: false) => (
        Icons.cloud_off,
        context.colors.due,
        context.colors.dueSoft,
        l10n.syncOffline,
      ),
      SyncStatus(lastSyncedAt: final DateTime at) => (
        Icons.cloud_done,
        context.colors.given,
        context.colors.givenSoft,
        l10n.syncedAt(Formatters.time(at, locale)),
      ),
      SyncStatus(lastSyncedAt: null) => (
        Icons.cloud_queue,
        context.colors.inkMuted,
        context.colors.surfaceMuted,
        l10n.syncNever,
      ),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      child: StatusPill(
        icon: icon,
        color: color,
        background: background,
        label: [
          text,
          if (status.pendingCount > 0) l10n.syncPending(status.pendingCount),
        ].join(' · '),
      ),
    );
  }
}
