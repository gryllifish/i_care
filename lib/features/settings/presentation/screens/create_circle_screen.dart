import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// A phone that belongs to nobody starts a circle: who cares, for whom.
/// Its person becomes the first admin (`docs/roles.md`).
class CreateCircleScreen extends ConsumerStatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  ConsumerState<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends ConsumerState<CreateCircleScreen> {
  final _yourName = TextEditingController();
  final _recipientName = TextEditingController();
  var _triedToSave = false;
  var _busy = false;

  @override
  void dispose() {
    _yourName.dispose();
    _recipientName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? missing(TextEditingController field) =>
        _triedToSave && field.text.trim().isEmpty
        ? l10n.issueNameMissing
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createCircle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          Text(l10n.createCircleBody, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xl),
          LabeledField(
            label: l10n.fieldYourName,
            controller: _yourName,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            error: missing(_yourName),
          ),
          const SizedBox(height: AppSpacing.lg),
          LabeledField(
            label: l10n.fieldRecipientName,
            controller: _recipientName,
            hint: l10n.fieldRecipientHint,
            textCapitalization: TextCapitalization.words,
            error: missing(_recipientName),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _busy ? null : _create,
            child: Text(l10n.createCircle),
          ),
        ],
      ),
    );
  }

  Future<void> _create() async {
    final l10n = context.l10n;
    setState(() => _triedToSave = true);
    final creatorName = _yourName.text.trim();
    final recipientName = _recipientName.text.trim();
    if (creatorName.isEmpty || recipientName.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(membershipActionsProvider.notifier)
        .createCircle(creatorName: creatorName, recipientName: recipientName);
    if (!mounted) return;
    setState(() => _busy = false);
    // On success the router moves on to the welcome.
    if (result case Err(:final failure)) {
      messenger.showError(
        failure is ForbiddenFailure ? l10n.circleExists : failure.message(l10n),
      );
    }
  }
}
