import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/settings/presentation/widgets/code_dialog.dart';
import 'package:i_care/features/settings/presentation/widgets/role_choices.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// Asks who to invite and as what, then shows their code.
Future<void> showInviteSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const InviteSheet(),
    );

class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({super.key});

  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet> {
  final _name = TextEditingController();
  MemberRole _role = MemberRole.caregiver;
  var _nameMissing = false;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        // Above the keyboard while typing.
        AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Text(l10n.inviteTitle, style: AppTextStyles.headline),
          LabeledField(
            label: l10n.fieldName,
            controller: _name,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            error: _nameMissing ? l10n.issueNameMissing : null,
          ),
          Text(l10n.fieldRole, style: AppTextStyles.label),
          RoleChoices(
            selected: _role,
            onChanged: (role) => setState(() => _role = role),
          ),
          FilledButton(
            onPressed: _busy ? null : _invite,
            child: Text(l10n.invite),
          ),
        ],
      ),
    );
  }

  Future<void> _invite() async {
    final l10n = context.l10n;
    final name = _name.text.trim();
    setState(() => _nameMissing = name.isEmpty);
    if (name.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(membershipActionsProvider.notifier)
        .invite(name: name, role: _role);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok(value: final code):
        navigator.pop();
        await showCodeDialog(navigator.context, name: name, code: code);
      case Err(:final failure):
        // The invitation stands when only the code failed (offline): a
        // new code can be asked for from the member later.
        messenger.showError(failure.message(l10n));
    }
  }
}
