import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/core/utils/parsers.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';
import 'package:i_care/features/medications/controllers/medication_actions.dart';
import 'package:i_care/features/medications/controllers/medication_detail.dart';
import 'package:i_care/features/medications/controllers/schedule_draft.dart';
import 'package:i_care/features/medications/presentation/widgets/schedule_editor.dart';
import 'package:i_care/features/medications/presentation/widgets/stock_input.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';
import 'package:i_care/shared/widgets/number_stepper.dart';
import 'package:i_care/shared/widgets/save_button.dart';

/// Adds a medication, or edits the details of [medicationId]. The
/// schedule is set here only when adding; later it changes on its own
/// screen, so earlier doses keep theirs.
class MedicationFormScreen extends ConsumerWidget {
  const MedicationFormScreen({this.medicationId, super.key});

  final String? medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = medicationId;
    if (id == null) return const _MedicationForm(editing: null);
    // Opened directly (a reload on the web), the log may still be loading.
    return switch (ref.watch(medicationDetailProvider(id))) {
      AsyncData(value: final MedicationDetail detail) => _MedicationForm(
        editing: detail.medication,
      ),
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

class _MedicationForm extends ConsumerStatefulWidget {
  const _MedicationForm({required this.editing});

  /// Null when adding a new medication.
  final Medication? editing;

  @override
  ConsumerState<_MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends ConsumerState<_MedicationForm> {
  late final TextEditingController _name;
  late final TextEditingController _strength;
  late final TextEditingController _instructions;
  final _stock = TextEditingController();
  late MedicationForm _form;
  late double _unitsPerDose;
  late int _lowStockDays;
  ScheduleDraft _schedule = const ScheduleDraft();
  Set<MedicationIssue> _issues = const {};
  var _triedToSave = false;
  var _stockInvalid = false;
  var _busy = false;

  static const _unitsStep = 0.5;
  static const _maxUnits = 10.0;
  static const _maxLowStockDays = 30;

  @override
  void initState() {
    super.initState();
    final details = widget.editing?.details;
    _name = TextEditingController(text: details?.name);
    _strength = TextEditingController(text: details?.strength);
    _instructions = TextEditingController(text: details?.instructions);
    _form = details?.form ?? MedicationForm.tablet;
    _unitsPerDose = details?.unitsPerDose ?? 1;
    _lowStockDays = details?.lowStockDays ?? 7;
  }

  @override
  void dispose() {
    _name.dispose();
    _strength.dispose();
    _instructions.dispose();
    _stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final isNew = widget.editing == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? l10n.newMedication : l10n.editMedication),
        actions: [SaveButton(onPressed: _busy ? null : _save)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          FormSection(
            title: l10n.sectionMedication,
            children: [
              LabeledField(
                label: l10n.fieldName,
                controller: _name,
                textCapitalization: TextCapitalization.sentences,
                error: _issues.contains(MedicationIssue.nameMissing)
                    ? MedicationIssue.nameMissing.message(l10n)
                    : null,
              ),
              LabeledField(
                label: l10n.fieldStrength,
                controller: _strength,
                hint: l10n.fieldStrengthHint,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Text(l10n.fieldForm, style: AppTextStyles.label),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final form in MedicationForm.values)
                        ChoiceChip(
                          label: Text(form.label(l10n)),
                          selected: form == _form,
                          showCheckmark: false,
                          onSelected: (_) => setState(() => _form = form),
                        ),
                    ],
                  ),
                ],
              ),
              LabeledField(
                label: l10n.fieldInstructions,
                controller: _instructions,
                hint: l10n.fieldInstructionsHint,
                textCapitalization: TextCapitalization.sentences,
                multiline: true,
              ),
            ],
          ),
          if (isNew)
            FormSection(
              title: l10n.scheduleTitle,
              children: [
                ScheduleEditor(
                  draft: _schedule,
                  showIssues: _triedToSave,
                  onChanged: (draft) => setState(() => _schedule = draft),
                ),
              ],
            ),
          FormSection(
            title: l10n.sectionDoseAndStock,
            children: [
              NumberStepper(
                label: l10n.fieldUnitsPerDose,
                valueText: Formatters.units(_unitsPerDose, locale),
                onDecrease: _unitsPerDose <= _unitsStep
                    ? null
                    : () => setState(() => _unitsPerDose -= _unitsStep),
                onIncrease: _unitsPerDose >= _maxUnits
                    ? null
                    : () => setState(() => _unitsPerDose += _unitsStep),
              ),
              if (isNew)
                StockInput(
                  controller: _stock,
                  label: l10n.fieldInitialStock,
                  isInvalid: _stockInvalid,
                ),
              NumberStepper(
                label: l10n.fieldLowStockDays,
                valueText: l10n.daysValue(_lowStockDays),
                onDecrease: _lowStockDays <= 0
                    ? null
                    : () => setState(() => _lowStockDays--),
                onIncrease: _lowStockDays >= _maxLowStockDays
                    ? null
                    : () => setState(() => _lowStockDays++),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              const Icon(Icons.info_outline, color: AppColors.inkMuted),
              Expanded(
                child: Text(
                  l10n.prescriptionNote,
                  style: AppTextStyles.bodyMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final details = MedicationDetails(
      name: _name.text.trim(),
      strength: _strength.text.trim(),
      form: _form,
      instructions: _instructions.text.trim(),
      unitsPerDose: _unitsPerDose,
      lowStockDays: _lowStockDays,
    );
    final editing = widget.editing;
    final stockText = _stock.text.trim();
    final stock = parseUnits(stockText);
    final issues = {
      ...validateDetails(details),
      if (editing == null) ..._schedule.issues,
    };
    final stockInvalid = stockText.isNotEmpty && stock == null;
    setState(() {
      _issues = issues;
      _stockInvalid = stockInvalid;
      _triedToSave = true;
    });
    if (issues.isNotEmpty || stockInvalid) return;

    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(medicationActionsProvider.notifier);
    setState(() => _busy = true);
    final result = editing == null
        ? await actions.create(
            details: details,
            schedule: _schedule.toSchedule(),
            initialStock: stock,
          )
        : await actions.updateDetails(editing, details);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.medicationSaved(details.name))),
        );
        context.pop();
      case Err(:final failure):
        messenger.showSnackBar(
          SnackBar(content: Text(failure.message(l10n))),
        );
    }
  }
}
