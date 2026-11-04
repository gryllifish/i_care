import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/form_section.dart';

/// Whether this phone is told about the circle's news, where this build
/// has push notifications (the beta on Android and the web). The system's
/// permission decides; a button shows only while it was never asked.
class NotificationsSection extends ConsumerStatefulWidget {
  const NotificationsSection({super.key});

  @override
  ConsumerState<NotificationsSection> createState() =>
      _NotificationsSectionState();
}

class _NotificationsSectionState extends ConsumerState<NotificationsSection> {
  /// While the system asks and the server keeps the token.
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final permission = ref.watch(pushNotificationsProvider).value;
    if (permission == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    return FormSection(
      title: l10n.sectionNotifications,
      children: [
        AppCard(
          raised: false,
          color: context.colors.surfaceMuted,
          child: Text(switch (permission) {
            PushPermission.allowed => l10n.notificationsOn,
            PushPermission.denied => l10n.notificationsOff,
            PushPermission.notAsked => l10n.notificationsBody,
          }, style: AppTextStyles.body),
        ),
        if (permission == PushPermission.allowed)
          Text(
            l10n.notificationsBody,
            style: AppTextStyles.bodyMuted.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
        if (permission == PushPermission.notAsked)
          FilledButton.icon(
            onPressed: _busy ? null : _turnOn,
            icon: const Icon(Icons.notifications_active_outlined),
            label: Text(l10n.notificationsTurnOn),
          ),
      ],
    );
  }

  Future<void> _turnOn() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref.read(pushNotificationsProvider.notifier).request();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
  }
}
