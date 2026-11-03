import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/reason_actions.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// Which reasons are offered when a dose is not given or a task not done,
/// and the circle's own. Opened from Settings and from the reason picker,
/// by whoever manages them; empty for anyone else.
class ReasonsScreen extends ConsumerWidget {
  const ReasonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final log = ref.watch(careLogProvider).value;
    final canManage = ref.watch(canDoProvider(CareAction.manageReasons));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sectionReasons)),
      body: log == null || !canManage
          ? const SizedBox.shrink()
          : _Reasons(log: log),
    );
  }
}

class _Reasons extends ConsumerWidget {
  const _Reasons({required this.log});

  final CareLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final hidden = log.hiddenReasons;
    final customReasons = log.customReasonLabels;
    // Every reason a circle can switch: "Other" is always offered.
    final switchable = [
      for (final reason in SkipReason.values)
        if (reason != SkipReason.other) reason.id,
      ...customReasons.keys,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      children: [
        Text(
          l10n.reasonsNote,
          style: AppTextStyles.bodyMuted.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final reasonId in switchable)
                SwitchListTile(
                  value: !hidden.contains(reasonId),
                  onChanged: (offered) =>
                      _switch(context, ref, reasonId, offered),
                  title: Text(
                    reasonLabel(l10n, reasonId, customReasons: customReasons),
                    style: AppTextStyles.body,
                  ),
                  subtitle: switch (reasonId) {
                    _ when reasonId == SkipReason.doctorAdvice.id => Text(
                      l10n.reasonMedicationsOnly,
                    ),
                    _ when customReasons.containsKey(reasonId) => Text(
                      l10n.reasonOwn,
                    ),
                    _ => null,
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const _AddReason(),
      ],
    );
  }

  Future<void> _switch(
    BuildContext context,
    WidgetRef ref,
    String reasonId,
    bool offered,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(reasonActionsProvider.notifier);
    final result = offered
        ? await actions.show(reasonId)
        : await actions.hide(reasonId);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
  }
}

class _AddReason extends ConsumerStatefulWidget {
  const _AddReason();

  @override
  ConsumerState<_AddReason> createState() => _AddReasonState();
}

class _AddReasonState extends ConsumerState<_AddReason> {
  final _label = TextEditingController();
  var _invalid = false;
  var _busy = false;

  static const _buttonHeight = 48.0;

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        LabeledField(
          label: l10n.fieldNewReason,
          controller: _label,
          hint: l10n.fieldNewReasonHint,
          textCapitalization: TextCapitalization.sentences,
          error: _invalid ? l10n.reasonExists : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _busy ? null : _add,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, _buttonHeight),
            ),
            child: Text(l10n.addReason),
          ),
        ),
      ],
    );
  }

  Future<void> _add() async {
    final l10n = context.l10n;
    final label = _label.text;
    final isNew =
        ref.read(careLogProvider).value?.isNewReasonLabel(label) ?? false;
    setState(() => _invalid = !isNew);
    if (!isNew) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref.read(reasonActionsProvider.notifier).add(label);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        _label.clear();
        FocusScope.of(context).unfocus();
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }
}
