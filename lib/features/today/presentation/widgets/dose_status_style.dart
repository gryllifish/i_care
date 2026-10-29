import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';

/// How a dose's state looks. Color always comes with an icon and a label,
/// so it never carries meaning alone.
typedef DoseStatusStyle = ({
  IconData icon,
  Color color,
  Color background,
  String label,
});

extension DoseSlotStyle on DoseSlot {
  DoseStatusStyle style(AppLocalizations l10n) {
    if (hasConflict) {
      return (
        icon: Icons.error,
        color: AppColors.overdue,
        background: AppColors.overdueSoft,
        label: l10n.statusGivenTwice,
      );
    }
    return switch (status) {
      DoseStatus.upcoming => (
        icon: Icons.schedule,
        color: AppColors.inkMuted,
        background: AppColors.skippedSoft,
        label: l10n.statusUpcoming,
      ),
      DoseStatus.due => (
        icon: Icons.notifications_active,
        color: AppColors.due,
        background: AppColors.dueSoft,
        label: l10n.statusDue,
      ),
      DoseStatus.overdue => (
        icon: Icons.warning_amber,
        color: AppColors.overdue,
        background: AppColors.overdueSoft,
        label: l10n.statusOverdue,
      ),
      DoseStatus.given => (
        icon: Icons.check_circle,
        color: AppColors.given,
        background: AppColors.givenSoft,
        label: isDouble ? l10n.statusGivenTwice : l10n.statusGiven,
      ),
      DoseStatus.skipped => (
        icon: Icons.remove_circle_outline,
        color: AppColors.skipped,
        background: AppColors.skippedSoft,
        label: l10n.statusSkipped,
      ),
    };
  }
}
