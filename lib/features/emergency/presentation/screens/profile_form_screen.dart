import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/emergency/controllers/emergency_card.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';
import 'package:i_care/shared/widgets/save_button.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

/// Edits the emergency card's profile.
class ProfileFormScreen extends ConsumerWidget {
  const ProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Opened directly (a reload on the web), the log may still be loading.
    return switch (ref.watch(emergencyCardProvider)) {
      AsyncData(:final value) => _ProfileForm(card: value),
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

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.card});

  final EmergencyCard card;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  late final TextEditingController _name;
  late final TextEditingController _allergies;
  late final TextEditingController _conditions;
  late final TextEditingController _notes;
  late final List<_ContactFields> _doctors;
  late final List<_ContactFields> _contacts;
  DateTime? _birthDate;
  var _nameMissing = false;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.card.profile;
    _name = TextEditingController(text: profile?.name);
    _allergies = TextEditingController(text: profile?.allergies);
    _conditions = TextEditingController(text: profile?.conditions);
    _notes = TextEditingController(text: profile?.notes);
    _doctors = [
      for (final c in profile?.doctors ?? const <CareContact>[])
        _ContactFields(c),
    ];
    _contacts = [
      for (final c in profile?.contacts ?? const <CareContact>[])
        _ContactFields(c),
    ];
    _birthDate = profile?.birthDate;
  }

  @override
  void dispose() {
    for (final controller in [_name, _allergies, _conditions, _notes]) {
      controller.dispose();
    }
    for (final fields in [..._doctors, ..._contacts]) {
      fields.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final birthDate = _birthDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
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
            title: l10n.sectionPerson,
            children: [
              LabeledField(
                label: l10n.fieldFullName,
                controller: _name,
                textCapitalization: TextCapitalization.words,
                error: _nameMissing ? l10n.issueNameMissing : null,
              ),
              _DateField(
                label: l10n.fieldBirthDate,
                text: birthDate == null
                    ? l10n.notSet
                    : Formatters.fullDate(birthDate, locale),
                onTap: _pickBirthDate,
              ),
              LabeledField(
                label: l10n.fieldAllergies,
                controller: _allergies,
                textCapitalization: TextCapitalization.sentences,
                multiline: true,
              ),
              LabeledField(
                label: l10n.fieldConditions,
                controller: _conditions,
                textCapitalization: TextCapitalization.sentences,
                multiline: true,
              ),
              LabeledField(
                label: l10n.fieldNotes,
                controller: _notes,
                textCapitalization: TextCapitalization.sentences,
                multiline: true,
              ),
            ],
          ),
          FormSection(
            title: l10n.doctorsTitle,
            children: [
              for (final fields in _doctors)
                _ContactEditor(
                  fields: fields,
                  roleLabel: l10n.fieldSpecialty,
                  onRemove: () => setState(() => _doctors.remove(fields)),
                ),
              _AddButton(
                label: l10n.addDoctor,
                onPressed: () => setState(() => _doctors.add(_ContactFields())),
              ),
            ],
          ),
          FormSection(
            title: l10n.contactsTitle,
            children: [
              for (final fields in _contacts)
                _ContactEditor(
                  fields: fields,
                  roleLabel: l10n.fieldRelationship,
                  onRemove: () => setState(() => _contacts.remove(fields)),
                ),
              _AddButton(
                label: l10n.addContact,
                onPressed: () =>
                    setState(() => _contacts.add(_ContactFields())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final today = ref.read(clockProvider)();
    final picked = await showDateWheel(
      context,
      initial: _birthDate ?? DateTime(today.year - 80),
      first: DateTime(1900),
      last: today,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    setState(() => _nameMissing = name.isEmpty);
    if (name.isEmpty) return;

    final profile = RecipientProfile(
      name: name,
      birthDate: _birthDate,
      allergies: _allergies.text.trim(),
      conditions: _conditions.text.trim(),
      notes: _notes.text.trim(),
      doctors: [
        for (final fields in _doctors) ?fields.toContact(),
      ],
      contacts: [
        for (final fields in _contacts) ?fields.toContact(),
      ],
    );
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(profileActionsProvider.notifier)
        .update(profile, base: widget.card.profileVersion);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.medicationSaved(profile.name))),
        );
        context.pop();
      case Err(:final failure):
        messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
    }
  }
}

/// The text fields of one contact being edited.
class _ContactFields {
  _ContactFields([CareContact? contact])
    : name = TextEditingController(text: contact?.name),
      role = TextEditingController(text: contact?.role),
      phone = TextEditingController(text: contact?.phone);

  final TextEditingController name;
  final TextEditingController role;
  final TextEditingController phone;

  /// The contact, or null when the name was left empty.
  CareContact? toContact() => name.text.trim().isEmpty
      ? null
      : CareContact(
          name: name.text.trim(),
          role: role.text.trim(),
          phone: phone.text.trim(),
        );

  void dispose() {
    name.dispose();
    role.dispose();
    phone.dispose();
  }
}

class _ContactEditor extends StatelessWidget {
  const _ContactEditor({
    required this.fields,
    required this.roleLabel,
    required this.onRemove,
  });

  final _ContactFields fields;
  final String roleLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      raised: false,
      color: AppColors.surfaceMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          LabeledField(
            label: l10n.fieldPersonName,
            controller: fields.name,
            textCapitalization: TextCapitalization.words,
          ),
          LabeledField(
            label: roleLabel,
            controller: fields.role,
            textCapitalization: TextCapitalization.sentences,
          ),
          LabeledField(
            label: l10n.fieldPhone,
            controller: fields.phone,
            keyboardType: TextInputType.phone,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRemove,
              style: TextButton.styleFrom(foregroundColor: AppColors.overdue),
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.remove),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_circle),
      label: Text(label),
    ),
  );
}

/// A field-shaped button showing a chosen date.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.text,
    required this.onTap,
  });

  final String label;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(label, style: AppTextStyles.label),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  const Icon(Icons.cake_outlined, color: AppColors.teal),
                  Expanded(child: Text(text, style: AppTextStyles.body)),
                  const Icon(Icons.expand_more, color: AppColors.inkMuted),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
