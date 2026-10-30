import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';
import 'package:i_care/features/today/controllers/dose_controller.dart';
import 'package:i_care/features/today/presentation/widgets/dose_status_style.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

/// Opens the sheet to record the dose of [medicationId] scheduled at
/// [slotAt], or an as-needed dose when [slotAt] is null.
Future<void> showDoseSheet(
  BuildContext context, {
  required String medicationId,
  required DateTime? slotAt,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => DoseSheet(medicationId: medicationId, slotAt: slotAt),
);

/// Records the dose in [detail] as given at [givenAt] (now when null),
/// counting the doses its warnings showed as known, and confirms it with
/// an undo option.
Future<void> recordDoseGiven(
  BuildContext context,
  WidgetRef ref, {
  required DoseDetail detail,
  required DateTime? slotAt,
  DateTime? givenAt,
}) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final actions = ref.read(doseActionsProvider.notifier);
  final isConnected = ref.read(syncStatusProvider).value?.isConnected ?? true;
  final name = detail.medication.details.name;

  final result = await actions.give(
    detail.medication,
    slotAt: slotAt,
    givenAt: givenAt,
    knownDoseIds: knownDoseIdsOf(detail.warnings),
  );
  switch (result) {
    case Ok(:final value):
      messenger.showMessage(
        isConnected
            ? l10n.doseRecordedGiven(name)
            : l10n.doseRecordedOffline(name),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => actions.undo(value),
        ),
      );
    case Err(:final failure):
      messenger.showError(failure.message(l10n));
  }
}

class DoseSheet extends ConsumerStatefulWidget {
  const DoseSheet({
    required this.medicationId,
    required this.slotAt,
    super.key,
  });

  final String medicationId;
  final DateTime? slotAt;

  @override
  ConsumerState<DoseSheet> createState() => _DoseSheetState();
}

class _DoseSheetState extends ConsumerState<DoseSheet> {
  var _choosingReason = false;
  var _busy = false;

  /// Whether a dose someone already recorded is being recorded again,
  /// because this caregiver gave it too.
  var _givingToo = false;
  _GivenAtChoice _givenAt = const _GivenNow();

  @override
  Widget build(BuildContext context) {
    final DoseDetail detail;
    final givenAt = _givenAt.resolve(ref.watch(nowProvider));
    switch (ref.watch(
      doseDetailProvider(widget.medicationId, widget.slotAt, givenAt: givenAt),
    )) {
      case AsyncData(:final DoseDetail value):
        detail = value;
      case AsyncLoading():
        return const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        );
      case _:
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(context.l10n.errorNotFound, style: AppTextStyles.body),
        );
    }

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final details = detail.medication.details;
    final slot = detail.slot;
    final isGiven = slot != null && slot.status == DoseStatus.given;
    final isResolved = isGiven || slot?.status == DoseStatus.skipped;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Text(
            '${details.name} ${details.strength}',
            style: AppTextStyles.headline,
          ),
          Text(
            [
              if (slot != null)
                l10n.scheduledAt(Formatters.time(slot.slotAt, locale))
              else
                l10n.asNeeded,
              if (slot != null) slot.style(l10n, context.colors).label,
            ].join(' · '),
            style: AppTextStyles.body,
          ),
          if (details.instructions.isNotEmpty)
            Text(
              details.instructions,
              style: AppTextStyles.bodyMuted.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          if (detail.conflicts.isNotEmpty) ...[
            _Notice(
              icon: Icons.error,
              color: context.colors.overdue,
              background: context.colors.overdueSoft,
              title: l10n.statusGivenTwice,
              lines: [l10n.conflictExplanation],
            ),
            _History(detail: detail),
            Text(
              l10n.conflictQuestion(
                SampleCircle.recipientName,
                _conflictDoseCount(detail),
              ),
              style: AppTextStyles.title,
            ),
            FilledButton(
              onPressed: _busy ? null : () => _keepOnlyOne(detail),
              child: Text(l10n.conflictOnlyOne),
            ),
            OutlinedButton(
              onPressed: _busy ? null : () => _confirmAll(detail),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(_secondaryButtonHeight),
              ),
              child: Text(l10n.conflictAllGiven(_conflictDoseCount(detail))),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(_secondaryButtonHeight),
              ),
              child: Text(l10n.conflictNotSure),
            ),
          ] else ...[
            if (slot?.isDouble ?? false)
              _Notice(
                icon: Icons.info_outline,
                color: context.colors.inkMuted,
                background: context.colors.skippedSoft,
                title: l10n.statusGivenTwice,
                lines: [l10n.doubleDoseBody],
              ),
            _History(detail: detail, onRemove: _remove),
            // A dose already given is corrected from its records above;
            // recording it again is only for a second dose really given.
            if (isGiven && !_givingToo)
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _givingToo = true),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(_secondaryButtonHeight),
                ),
                child: Text(l10n.givenToo),
              )
            else ...[
              if (detail.warnings.isNotEmpty)
                _Notice(
                  icon: Icons.warning_amber,
                  color: context.colors.due,
                  background: context.colors.dueSoft,
                  title: l10n.checkBeforeGiving,
                  lines: [
                    for (final warning in detail.warnings)
                      warning.text(
                        l10n,
                        locale: locale,
                        caregivers: ref.watch(caregiversByIdProvider),
                      ),
                  ],
                ),
              if (_choosingReason && slot != null)
                _ReasonPicker(
                  onPicked: _busy
                      ? null
                      : (reason) => _skip(detail, slot, reason),
                )
              else ...[
                _GivenAtPicker(
                  choice: _givenAt,
                  onChanged: (choice) => setState(() => _givenAt = choice),
                ),
                FilledButton(
                  onPressed: _busy ? null : () => _give(detail),
                  child: Text(
                    detail.warnings.isEmpty
                        ? l10n.markGiven
                        : l10n.markGivenAnyway,
                  ),
                ),
                if (slot != null && !isResolved)
                  OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() => _choosingReason = true),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        _secondaryButtonHeight,
                      ),
                    ),
                    child: Text(l10n.skipDose),
                  ),
              ],
            ],
          ],
        ],
      ),
    );
  }

  static const _secondaryButtonHeight = 48.0;

  Future<void> _give(DoseDetail detail) async {
    setState(() => _busy = true);
    await recordDoseGiven(
      context,
      ref,
      detail: detail,
      slotAt: widget.slotAt,
      givenAt: _givenAt.resolve(ref.read(clockProvider)()),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _skip(
    DoseDetail detail,
    DoseSlot slot,
    SkipReason reason,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(doseActionsProvider.notifier);
    setState(() => _busy = true);

    final result = await actions.skip(
      detail.medication,
      slotAt: slot.slotAt,
      reason: reason,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    switch (result) {
      case Ok(:final value):
        messenger.showMessage(
          l10n.doseRecordedSkipped(detail.medication.details.name),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () => actions.undo(value),
          ),
        );
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }

  /// Takes back a record made by mistake, after confirming. It appends an
  /// undo event, so Activity still shows both.
  Future<void> _remove(CareEvent record) async {
    if (_busy) return;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(doseActionsProvider.notifier);
    final caregiverId = record.meta.caregiverId;
    final name =
        ref.read(caregiversByIdProvider)[caregiverId]?.name ??
        l10n.unknownCaregiver;

    final confirmed = await showConfirmDialog(
      context,
      title: l10n.removeRecordTitle,
      body: switch (record) {
        DoseGiven(:final givenAt) => l10n.removeGivenBody(
          name,
          Formatters.time(givenAt, locale),
        ),
        _ => l10n.removeSkippedBody(name),
      },
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.remove,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    final result = await actions.undo(record);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _givingToo = false;
    });
    switch (result) {
      case Ok():
        messenger.showMessage(l10n.recordRemoved);
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }

  /// The doses were one and the same: cancels every record after the
  /// first, so the dose reads as given once.
  Future<void> _keepOnlyOne(DoseDetail detail) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(doseActionsProvider.notifier);
    setState(() => _busy = true);

    final repeated = {
      for (final conflict in detail.conflicts) ...conflict.doses.skip(1),
    };
    for (final dose in repeated) {
      await actions.undo(dose);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showMessage(l10n.conflictResolvedOne);
  }

  /// Every dose was really given: the conflict is reviewed and the dose
  /// stays marked as given more than once.
  Future<void> _confirmAll(DoseDetail detail) async {
    final actions = ref.read(doseActionsProvider.notifier);
    setState(() => _busy = true);
    for (final conflict in detail.conflicts) {
      await actions.acknowledge(conflict.key);
    }
    if (mounted) setState(() => _busy = false);
  }
}

int _conflictDoseCount(DoseDetail detail) => detail.conflicts
    .map((conflict) => conflict.doses.length)
    .fold(0, (most, count) => count > most ? count : most);

/// When the caregiver says the dose was given, relative to when they
/// record it.
sealed class _GivenAtChoice {
  const _GivenAtChoice();

  /// The moment it stands for at [now]; null means now.
  DateTime? resolve(DateTime now);
}

final class _GivenNow extends _GivenAtChoice {
  const _GivenNow();

  @override
  DateTime? resolve(DateTime now) => null;
}

final class _GivenAgo extends _GivenAtChoice {
  const _GivenAgo(this.ago);

  final Duration ago;

  @override
  DateTime resolve(DateTime now) => now.subtract(ago);
}

final class _GivenAt extends _GivenAtChoice {
  const _GivenAt(this.at);

  final DateTime at;

  @override
  DateTime resolve(DateTime now) => at;
}

/// "Now", a recent moment, or a picked time. A picked time later than now
/// means yesterday: a dose from last night recorded in the morning.
class _GivenAtPicker extends ConsumerWidget {
  const _GivenAtPicker({required this.choice, required this.onChanged});

  final _GivenAtChoice choice;
  final ValueChanged<_GivenAtChoice> onChanged;

  static const _recent = [Duration(minutes: 30), Duration(hours: 1)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();

    String agoLabel(Duration ago) => ago.inMinutes < Duration.minutesPerHour
        ? l10n.givenMinutesAgo(ago.inMinutes)
        : l10n.givenHoursAgo(ago.inHours);

    Future<void> pickTime() async {
      final now = ref.read(clockProvider)();
      final picked = await showTimeWheel(
        context,
        initial: TimeOfDay.fromDateTime(now),
      );
      if (picked == null) return;
      onChanged(_GivenAt(latestAt(picked.hour, picked.minute, now)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(l10n.givenWhen, style: AppTextStyles.label),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.givenNow),
              selected: choice is _GivenNow,
              onSelected: (_) => onChanged(const _GivenNow()),
            ),
            for (final ago in _recent)
              ChoiceChip(
                label: Text(agoLabel(ago)),
                selected: switch (choice) {
                  _GivenAgo(ago: final selected) => selected == ago,
                  _ => false,
                },
                onSelected: (_) => onChanged(_GivenAgo(ago)),
              ),
            ChoiceChip(
              label: Text(switch (choice) {
                _GivenAt(:final at) => l10n.givenAtTime(
                  Formatters.time(at, locale),
                ),
                _ => l10n.givenPickTime,
              }),
              selected: choice is _GivenAt,
              onSelected: (_) => pickTime(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Who recorded what for this dose, each record with a button to take it
/// back when [onRemove] is set.
class _History extends ConsumerWidget {
  const _History({required this.detail, this.onRemove});

  final DoseDetail detail;
  final ValueChanged<CareEvent>? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final caregivers = ref.watch(caregiversByIdProvider);
    final skipped = detail.slot?.skipped ?? const <DoseSkipped>[];
    if (detail.history.isEmpty && skipped.isEmpty) {
      return const SizedBox.shrink();
    }

    String nameOf(String id) => caregivers[id]?.name ?? l10n.unknownCaregiver;
    final onRemove = this.onRemove;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          detail.slot == null ? l10n.recordedToday : l10n.recordedForThisDose,
          style: AppTextStyles.label,
        ),
        for (final dose in detail.history)
          _HistoryRow(
            caregiver: caregivers[dose.meta.caregiverId],
            name: nameOf(dose.meta.caregiverId),
            text: recordedByText(
              l10n,
              name: nameOf(dose.meta.caregiverId),
              at: dose.givenAt,
              slotAt: dose.slotAt,
              today: ref.watch(nowProvider),
              locale: locale,
            ),
            onRemove: onRemove == null ? null : () => onRemove(dose),
          ),
        for (final skip in skipped)
          _HistoryRow(
            caregiver: caregivers[skip.meta.caregiverId],
            name: nameOf(skip.meta.caregiverId),
            text: l10n.skippedBy(
              nameOf(skip.meta.caregiverId),
              skip.reason.label(l10n),
            ),
            onRemove: onRemove == null ? null : () => onRemove(skip),
          ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.caregiver,
    required this.name,
    required this.text,
    required this.onRemove,
  });

  final Caregiver? caregiver;
  final String name;
  final String text;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final caregiver = this.caregiver;
    final onRemove = this.onRemove;
    return Row(
      spacing: AppSpacing.md,
      children: [
        if (caregiver != null) CaregiverAvatar(caregiver: caregiver),
        Expanded(child: Text(text, style: AppTextStyles.body)),
        if (onRemove != null)
          TextButton(
            onPressed: onRemove,
            child: Text(
              context.l10n.remove,
              semanticsLabel: context.l10n.removeRecordOf(name),
            ),
          ),
      ],
    );
  }
}

class _ReasonPicker extends StatelessWidget {
  const _ReasonPicker({required this.onPicked});

  final ValueChanged<SkipReason>? onPicked;

  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onPicked = this.onPicked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(l10n.skipReasonTitle, style: AppTextStyles.label),
        for (final reason in SkipReason.values)
          OutlinedButton(
            onPressed: onPicked == null ? null : () => onPicked(reason),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(_buttonHeight),
            ),
            child: Text(reason.label(l10n)),
          ),
      ],
    );
  }
}

/// A highlighted box: a conflict, a warning or a note.
class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(icon, color: color),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.label.copyWith(color: color),
                ),
              ),
            ],
          ),
          for (final line in lines) Text(line, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
