import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';

/// Shown once the server says this phone is out of the circle: what
/// happened, before its copy of the log is cleared.
class RemovedScreen extends ConsumerStatefulWidget {
  const RemovedScreen({super.key});

  @override
  ConsumerState<RemovedScreen> createState() => _RemovedScreenState();
}

class _RemovedScreenState extends ConsumerState<RemovedScreen> {
  var _busy = false;

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
              child: Text(l10n.removedTitle, style: AppTextStyles.display),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.removedBody, style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _busy ? null : _forget,
              child: Text(l10n.removedOk),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _forget() async {
    setState(() => _busy = true);
    // The router moves on to joining once the device forgets the member.
    await ref.read(membershipActionsProvider.notifier).forget();
    if (mounted) setState(() => _busy = false);
  }
}
