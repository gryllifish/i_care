import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/task_actions.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/task_validation.dart';
import 'package:i_care/features/tasks/controllers/task_draft.dart';
import 'package:i_care/features/tasks/controllers/tasks_view.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/l10n/schedule_text.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/edit_conflict_card.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';
import 'package:i_care/shared/widgets/save_button.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';
import 'package:i_care/shared/widgets/times_and_days.dart';

/// Adds a care task, or edits [taskId]: its name, note and schedule.
class TaskFormScreen extends ConsumerWidget {
  const TaskFormScreen({this.taskId, super.key});

  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = taskId;
    if (id == null) return const _TaskForm(editing: null);
    // Opened directly (a reload on the web), the log may still be loading.
    return switch (ref.watch(taskRowProvider(id))) {
      AsyncData(value: final TaskRow row) when !row.task.isArchived =>
        _TaskForm(editing: row.task, conflicts: row.conflicts),
      AsyncLoading() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(context.l10n.errorNotFound, style: AppTextStyles.body),
        ),
      ),
    };
  }
}

class _TaskForm extends ConsumerStatefulWidget {
  const _TaskForm({required this.editing, this.conflicts = const []});

  /// Null when adding a new task.
  final CareTask? editing;
  final List<EditConflict> conflicts;

  @override
  ConsumerState<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<_TaskForm> {
  late final TextEditingController _name;
  late final TextEditingController _note;
  late TaskDraft _draft;
  Set<TaskIssue> _issues = const {};
  var _busy = false;

  @override
  void initState() {
    super.initState();
    final editing = widget.editing;
    _name = TextEditingController(text: editing?.details.name);
    _note = TextEditingController(text: editing?.details.note);
    _draft = editing == null
        ? const TaskDraft()
        : TaskDraft.from(editing.schedule);
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editing = widget.editing;
    String? errorFor(TaskIssue issue) =>
        _issues.contains(issue) ? issue.message(l10n) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing == null ? l10n.newTask : l10n.editTask),
        actions: [
          if (editing != null)
            PopupMenuButton<_MenuAction>(
              tooltip: l10n.more,
              onSelected: (action) => switch (action) {
                _MenuAction.archive => _archive(editing),
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _MenuAction.archive,
                  child: Text(l10n.archive),
                ),
              ],
            ),
          SaveButton(onPressed: _busy ? null : _save),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          if (editing != null)
            for (final conflict in widget.conflicts)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: _TaskConflict(conflict: conflict, task: editing),
              ),
          FormSection(
            title: l10n.sectionTask,
            children: [
              LabeledField(
                label: l10n.fieldName,
                controller: _name,
                hint: l10n.fieldTaskNameHint,
                textCapitalization: TextCapitalization.sentences,
                error: errorFor(TaskIssue.nameMissing),
              ),
              LabeledField(
                label: l10n.fieldNotes,
                controller: _note,
                hint: l10n.fieldTaskNoteHint,
                textCapitalization: TextCapitalization.sentences,
                multiline: true,
              ),
            ],
          ),
          FormSection(
            title: l10n.sectionWhen,
            children: [
              SegmentedControl<bool>(
                options: {false: l10n.duringTheDay, true: l10n.taskAtSetTimes},
                selected: _draft.atSetTimes,
                onChanged: (atSetTimes) => setState(
                  () => _draft = _draft.copyWith(atSetTimes: atSetTimes),
                ),
              ),
              if (_draft.atSetTimes)
                TimesField(
                  times: _draft.times,
                  onAdd: (minutes) =>
                      setState(() => _draft = _draft.withTime(minutes)),
                  onRemove: (minutes) =>
                      setState(() => _draft = _draft.withoutTime(minutes)),
                  error: errorFor(TaskIssue.noTimes),
                ),
              DaysField(
                everyDay: _draft.everyDay,
                days: _draft.days,
                onEveryDayChanged: (everyDay) => setState(
                  () => _draft = everyDay
                      ? _draft.copyWith(everyDay: true)
                      : _draft.chooseDays(),
                ),
                onToggleDay: (day) =>
                    setState(() => _draft = _draft.toggleDay(day)),
                error: errorFor(TaskIssue.noWeekdays),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final details = TaskDetails(
      name: _name.text.trim(),
      note: _note.text.trim(),
    );
    final issues = {...validateTaskDetails(details), ..._draft.issues};
    setState(() => _issues = issues);
    if (issues.isNotEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(taskActionsProvider.notifier);
    final editing = widget.editing;
    setState(() => _busy = true);
    final result = editing == null
        ? await actions.create(details: details, schedule: _draft.toSchedule())
        : await actions.update(
            editing,
            details: details,
            schedule: _draft.toSchedule(),
          );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        messenger.showMessage(l10n.medicationSaved(details.name));
        context.pop();
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }

  Future<void> _archive(CareTask task) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.archiveTitle(task.details.name),
      body: l10n.archiveBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.archive,
    );
    if (!confirmed || !mounted) return;
    final result = await ref.read(taskActionsProvider.notifier).archive(task);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
      return;
    }
    if (mounted) context.pop();
  }
}

enum _MenuAction { archive }

/// A concurrent edit of this task, to keep or undo.
class _TaskConflict extends ConsumerWidget {
  const _TaskConflict({required this.conflict, required this.task});

  final EditConflict conflict;
  final CareTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return EditConflictCard(
      conflict: conflict,
      summarize: (change) => switch (change) {
        TaskUpdated(:final details, :final schedule) => [
          details.name,
          schedule.describe(l10n, locale),
        ].join(' · '),
        TaskArchived() => l10n.changeArchived,
        _ => '',
      },
      // Back to the list after resolving: the fields here still hold the
      // values from before.
      onChoose: (change) async {
        final result = await ref
            .read(taskActionsProvider.notifier)
            .resolve(conflict, task, chosen: change);
        if (result is Ok && context.mounted) context.pop();
        return result;
      },
    );
  }
}
