import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';

/// One line saying how current this phone is with the others.
class SyncBanner extends ConsumerWidget {
  const SyncBanner({super.key});

  static const _iconSize = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStatusProvider).value ?? const SyncStatus();
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();

    final (icon, color, text) = switch (status) {
      SyncStatus(isConnected: false) => (
        Icons.cloud_off,
        AppColors.due,
        l10n.syncOffline,
      ),
      SyncStatus(lastSyncedAt: final DateTime at) => (
        Icons.cloud_done,
        AppColors.given,
        l10n.syncedAt(Formatters.time(at, locale)),
      ),
      SyncStatus(lastSyncedAt: null) => (
        Icons.cloud_queue,
        AppColors.inkMuted,
        l10n.syncNever,
      ),
    };

    return Semantics(
      liveRegion: true,
      child: Row(
        children: [
          Icon(icon, color: color, size: _iconSize),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              [
                text,
                if (status.pendingCount > 0)
                  l10n.syncPending(status.pendingCount),
              ].join(' · '),
              style: AppTextStyles.bodyMuted,
            ),
          ),
        ],
      ),
    );
  }
}
