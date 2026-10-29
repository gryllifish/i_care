import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/parsers.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/medications/controllers/medication_actions.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// A number field for units of a medication; accepts "1,5" and "1.5".
class StockInput extends StatelessWidget {
  const StockInput({
    required this.controller,
    required this.label,
    this.isInvalid = false,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool isInvalid;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: label,
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      error: isInvalid ? context.l10n.issueStockNumber : null,
    );
  }
}

/// Whether the stock sheet sets a counted amount or adds bought units.
enum StockChange { recount, refill }

Future<void> showStockSheet(
  BuildContext context, {
  required Medication medication,
  required StockChange change,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _StockSheet(medication: medication, change: change),
);

class _StockSheet extends ConsumerStatefulWidget {
  const _StockSheet({required this.medication, required this.change});

  final Medication medication;
  final StockChange change;

  @override
  ConsumerState<_StockSheet> createState() => _StockSheetState();
}

class _StockSheetState extends ConsumerState<_StockSheet> {
  final _units = TextEditingController();
  var _invalid = false;
  var _busy = false;

  /// Common box sizes, offered when adding bought units.
  static const _quickAmounts = [28, 30, 60];

  @override
  void dispose() {
    _units.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isRecount = widget.change == StockChange.recount;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Text(
            widget.medication.details.name,
            style: AppTextStyles.headline,
          ),
          StockInput(
            controller: _units,
            label: isRecount ? l10n.howManyLeft : l10n.howManyBought,
            isInvalid: _invalid,
            autofocus: true,
          ),
          if (!isRecount)
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final amount in _quickAmounts)
                  ActionChip(
                    label: Text('+$amount'),
                    onPressed: () => _units.text = '$amount',
                  ),
              ],
            ),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final units = parseUnits(_units.text);
    if (units == null) {
      setState(() => _invalid = true);
      return;
    }
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(medicationActionsProvider.notifier);
    setState(() => _busy = true);
    final result = switch (widget.change) {
      StockChange.recount => await actions.count(widget.medication, units),
      StockChange.refill => await actions.refill(widget.medication, units),
    };
    if (!mounted) return;
    if (result case Err(:final failure)) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
    }
    Navigator.of(context).pop();
  }
}
