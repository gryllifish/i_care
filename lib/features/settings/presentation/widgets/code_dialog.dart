import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';

/// Shows [code] for [name] to pass on, with a copy button.
Future<void> showCodeDialog(
  BuildContext context, {
  required String name,
  required InviteCode code,
}) => showDialog<void>(
  context: context,
  builder: (context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final when =
        '${Formatters.weekdayAndDate(code.expiresAt, locale)}, '
        '${Formatters.time(code.expiresAt, locale)}';
    return AlertDialog(
      title: Text(l10n.codeTitle(name)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            SelectableText(code.code, style: AppTextStyles.display),
            Text(l10n.codeValidUntil(when), style: AppTextStyles.body),
            Text(
              l10n.codeShareHint,
              style: AppTextStyles.bodyMuted.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await Clipboard.setData(ClipboardData(text: code.code));
            messenger.showMessage(l10n.codeCopied);
          },
          child: Text(l10n.copyCode),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  },
);
