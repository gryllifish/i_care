import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/form_section.dart';

/// Turns push notifications about the circle's news on or off, where this
/// build has them (the beta on Android and the web).
class NotificationsSection extends ConsumerStatefulWidget {
  const NotificationsSection({super.key});

  @override
  ConsumerState<NotificationsSection> createState() =>
      _NotificationsSectionState();
}

class _NotificationsSectionState extends ConsumerState<NotificationsSection> {
  /// While the system asks for permission and the server keeps the token.
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    if (ref.watch(pushRepositoryProvider) == null) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    return FormSection(
      title: l10n.sectionNotifications,
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: SwitchListTile(
            value: ref.watch(pushNotificationsProvider),
            onChanged: _busy ? null : _set,
            title: Text(l10n.notificationsSwitch, style: AppTextStyles.body),
            subtitle: Text(l10n.notificationsBody),
          ),
        ),
      ],
    );
  }

  Future<void> _set(bool enabled) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(pushNotificationsProvider.notifier)
        .set(enabled: enabled);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
  }
}
