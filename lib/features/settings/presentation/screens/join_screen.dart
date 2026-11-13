import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/config/demo_layout.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/access_actions.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// A phone that belongs to nobody: joins a circle with an invitation code
/// (`docs/roles.md`).
class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  final _code = TextEditingController();
  String? _error;
  var _busy = false;

  static const _buttonHeight = 48.0;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
          ),
          children: [
            Semantics(
              container: true,
              header: true,
              child: Text(l10n.joinTitle, style: AppTextStyles.display),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.joinBody, style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.xl),
            LabeledField(
              label: l10n.fieldCode,
              controller: _code,
              hint: l10n.fieldCodeHint,
              textCapitalization: TextCapitalization.characters,
              error: _error,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _busy ? null : _join,
              child: Text(l10n.join),
            ),
            if (ref.watch(accessOfferedProvider))
              TextButton(
                onPressed: _busy ? null : _recover,
                child: Text(l10n.alreadyHaveAccess),
              ),
            const SizedBox(height: AppSpacing.xxl),
            Text(l10n.createCircleLead, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.createCircleBody, style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => context.push(AppRoutes.createCircle),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(_buttonHeight),
              ),
              child: Text(l10n.createCircle),
            ),
            // Back to the sample, only in the demo.
            if (ref.watch(isDemoProvider)) ...[
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                raised: false,
                color: context.colors.surfaceMuted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    Text(
                      switch (ref.watch(demoLayoutProvider)) {
                        DemoLayout.twoPhones => l10n.joinDemoHint,
                        DemoLayout.onePhone => l10n.joinDemoHintOnePhone,
                      },
                      style: AppTextStyles.bodyMuted.copyWith(
                        color: context.colors.inkMuted,
                      ),
                    ),
                    TextButton(
                      onPressed: _busy ? null : _exploreSample,
                      child: Text(l10n.exploreSample),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Back to the demo's sample circle, each phone its owner's again.
  Future<void> _exploreSample() async {
    setState(() => _busy = true);
    await ref.read(demoResetProvider)();
    if (mounted) setState(() => _busy = false);
  }

  /// Back in with the Google account protecting one's access.
  Future<void> _recover() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref.read(protectedAccessProvider.notifier).recover();
    if (!mounted) return;
    // On success the router moves on to the welcome.
    setState(() => _busy = false);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
  }

  Future<void> _join() async {
    final code = _code.text.trim();
    if (code.isEmpty) return;
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(membershipActionsProvider.notifier)
        .join(code);
    if (!mounted) return;
    // On success the router moves on to the welcome.
    setState(() {
      _busy = false;
      if (result case Err(:final failure)) _error = failure.message(l10n);
    });
  }
}
