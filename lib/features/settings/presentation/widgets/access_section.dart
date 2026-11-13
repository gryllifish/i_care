import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/access_actions.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/form_section.dart';

/// Protecting this phone's access with a Google account, so its member
/// gets back into the circle on a new phone (`docs/roles.md`,
/// recoverable access). Shows nothing where it is not offered.
class AccessSection extends ConsumerStatefulWidget {
  const AccessSection({super.key});

  @override
  ConsumerState<AccessSection> createState() => _AccessSectionState();
}

class _AccessSectionState extends ConsumerState<AccessSection> {
  /// While Google's picker is open and the server links the account.
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(accessOfferedProvider)) return const SizedBox.shrink();
    final l10n = context.l10n;
    final email = ref.watch(protectedAccessProvider).value;
    final muted = AppTextStyles.bodyMuted.copyWith(
      color: context.colors.inkMuted,
    );
    return FormSection(
      title: l10n.sectionAccess,
      children: [
        if (email != null) ...[
          AppCard(
            raised: false,
            color: context.colors.surfaceMuted,
            child: Text(
              l10n.accessProtected(Formatters.maskedEmail(email)),
              style: AppTextStyles.body,
            ),
          ),
          Text(l10n.accessProtectedBody, style: muted),
        ] else ...[
          Text(l10n.accessBody, style: muted),
          FilledButton.icon(
            onPressed: _busy ? null : _protect,
            icon: const Icon(Icons.shield_outlined),
            label: Text(l10n.accessProtect),
          ),
        ],
      ],
    );
  }

  Future<void> _protect() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref.read(protectedAccessProvider.notifier).protect();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
  }
}
