import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/today/presentation/widgets/dose_status_style.dart';

extension TaskSlotStyle on TaskSlot {
  /// Like a dose's, but a late task is amber, not red: it matters, but
  /// it is not a missed medication.
  DoseStatusStyle style(AppLocalizations l10n, AppColors colors) =>
      switch (status) {
        TaskStatus.upcoming => (
          icon: Icons.schedule,
          color: colors.inkMuted,
          background: colors.skippedSoft,
          label: l10n.statusUpcoming,
        ),
        TaskStatus.due => (
          icon: Icons.notifications_active,
          color: colors.due,
          background: colors.dueSoft,
          label: isAnyTime ? l10n.statusToDoToday : l10n.statusDue,
        ),
        TaskStatus.late => (
          icon: Icons.warning_amber,
          color: colors.due,
          background: colors.dueSoft,
          label: l10n.statusOverdue,
        ),
        TaskStatus.done => (
          icon: Icons.check_circle,
          color: colors.given,
          background: colors.givenSoft,
          label: l10n.statusDone,
        ),
        TaskStatus.skipped => (
          icon: Icons.remove_circle_outline,
          color: colors.skipped,
          background: colors.skippedSoft,
          label: l10n.statusSkipped,
        ),
      };
}
