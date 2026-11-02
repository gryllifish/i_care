import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/settings/presentation/widgets/code_dialog.dart';
import 'package:i_care/features/today/presentation/widgets/dose_sheet.dart';
import 'package:i_care/features/today/presentation/widgets/task_sheet.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

import '../helpers/pump_app.dart';

/// Flutter's accessibility guidelines (tap targets of at least 48 dp, a
/// label on everything tappable, readable text contrast in the light and
/// the dark theme) and text at 200%
/// on every screen, sheet and dialog, filled with the sample circle.
void main() {
  final now = DateTime(2026, 11, 2, 9, 30);
  final today = DateTime(now.year, now.month, now.day);

  // The guidelines only check what is on screen: a tall phone fits each
  // screen whole.
  const tallPhone = Size(393, 3000);

  const themes = ['light', 'dark'];

  const routes = {
    'today': AppRoutes.today,
    'medications': AppRoutes.medications,
    'medication detail': '${AppRoutes.medications}/enalapril',
    'medication form': '${AppRoutes.medications}/${AppRoutes.newMedication}',
    'schedule change': '${AppRoutes.medications}/enalapril/schedule',
    'tasks': AppRoutes.tasks,
    'task form': '${AppRoutes.tasks}/${AppRoutes.newTask}',
    'task edit form': '${AppRoutes.tasks}/task-bath',
    'appointments': AppRoutes.appointments,
    'appointment detail': '${AppRoutes.appointments}/appointment-cardiology',
    'appointment form': '${AppRoutes.appointments}/${AppRoutes.newAppointment}',
    'activity': AppRoutes.activity,
    'emergency card': AppRoutes.emergency,
    'emergency profile form': '${AppRoutes.emergency}/edit',
    'handoff': AppRoutes.handoff,
    'settings': AppRoutes.settings,
    'welcome': AppRoutes.welcome,
    'join': AppRoutes.join,
  };

  /// Pumps the app on the sample circle in [language] and opens [path].
  Future<void> pumpAt(
    WidgetTester tester,
    String path, {
    String language = 'en',
    String theme = 'light',
    Size size = phoneSize,
  }) async {
    await pumpApp(
      tester,
      repository: FakeCareRepository(
        SampleCircle.events(now, language: language),
      )..status = SyncStatus(lastSyncedAt: now),
      now: now,
      size: size,
      prefs: MemoryDevicePrefs({
        // Until the phone joins, every route leads to joining; then, until
        // the welcome is seen, to the welcome.
        if (path != AppRoutes.join) PrefKeys.memberId: 'ana',
        if (path != AppRoutes.welcome) PrefKeys.welcomeSeen: 'true',
        PrefKeys.language: language,
        PrefKeys.themeMode: theme,
      }),
    );
    if (path == AppRoutes.welcome || path == AppRoutes.join) return;
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
    await tester.pumpAndSettle();
  }

  Future<void> expectGuidelines(WidgetTester tester) async {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  /// Text at 200%, the largest size most phones offer.
  void useLargeText(WidgetTester tester) {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }

  BuildContext screen(WidgetTester tester) =>
      tester.element(find.byType(Scaffold).last);

  /// Scrolls to [text] first: at 200 % it may be past what the list has
  /// built.
  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  Future<void> fromMenu(WidgetTester tester, String item) async {
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(item));
  }

  group('screens', () {
    for (final MapEntry(key: name, value: path) in routes.entries) {
      for (final theme in themes) {
        testWidgets('$name meets the guidelines in $theme', (tester) async {
          final handle = tester.ensureSemantics();
          await pumpAt(tester, path, theme: theme, size: tallPhone);

          await expectGuidelines(tester);
          handle.dispose();
        });
      }

      for (final language in ['en', 'es']) {
        testWidgets('$name fits text at 200% in $language', (tester) async {
          useLargeText(tester);
          await pumpAt(tester, path, language: language, size: tallPhone);

          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  /// Sheets and dialogs, each opened from the screen at its route.
  final overlays = <String, (String, Future<void> Function(WidgetTester))>{
    'dose sheet of a given dose': (
      AppRoutes.today,
      (tester) async => unawaited(
        showDoseSheet(
          screen(tester),
          medicationId: 'enalapril',
          slotAt: today.add(const Duration(hours: 8)),
        ),
      ),
    ),
    'dose sheet of a pending dose': (
      AppRoutes.today,
      (tester) async => unawaited(
        showDoseSheet(
          screen(tester),
          medicationId: 'enalapril',
          slotAt: today.add(const Duration(hours: 20)),
        ),
      ),
    ),
    'dose sheet of an as-needed dose': (
      AppRoutes.today,
      (tester) async => unawaited(
        showDoseSheet(
          screen(tester),
          medicationId: 'paracetamol',
          slotAt: null,
        ),
      ),
    ),
    'task sheet of a pending task': (
      AppRoutes.today,
      (tester) async => unawaited(
        showTaskSheet(screen(tester), taskId: 'task-skin', slotAt: today),
      ),
    ),
    'task sheet of a task done': (
      AppRoutes.today,
      (tester) async => unawaited(
        showTaskSheet(
          screen(tester),
          taskId: 'task-skin',
          slotAt: today.subtract(const Duration(days: 1)),
        ),
      ),
    ),
    'document link sheet': (
      '${AppRoutes.appointments}/appointment-cardiology',
      (tester) => tapText(tester, 'Add link'),
    ),
    'invite sheet': (
      AppRoutes.settings,
      (tester) => tapText(tester, 'Invite someone'),
    ),
    'member sheet': (AppRoutes.settings, (tester) => tapText(tester, 'Rosa')),
    'code dialog': (
      AppRoutes.settings,
      (tester) async => unawaited(
        showCodeDialog(
          screen(tester),
          name: 'Rosa',
          code: InviteCode(
            code: 'K7P-4QM',
            expiresAt: today.add(const Duration(days: 2)),
          ),
        ),
      ),
    ),
    'circle sheet': (
      AppRoutes.today,
      (tester) async {
        await tester.tap(find.bySemanticsLabel(RegExp('See the circle')));
      },
    ),
    'recount sheet': (
      '${AppRoutes.medications}/enalapril',
      (tester) => tapText(tester, 'Recount'),
    ),
    'refill sheet': (
      '${AppRoutes.medications}/enalapril',
      (tester) => tapText(tester, 'Bought more'),
    ),
    'archive dialog': (
      '${AppRoutes.medications}/enalapril',
      (tester) => fromMenu(tester, 'Archive'),
    ),
    'cancel appointment dialog': (
      '${AppRoutes.appointments}/appointment-cardiology',
      (tester) => fromMenu(tester, 'Cancel appointment'),
    ),
    'reset dialog': (
      AppRoutes.settings,
      (tester) => tapText(tester, 'Reset sample data'),
    ),
    'time wheel': (
      AppRoutes.today,
      (tester) async => unawaited(
        showTimeWheel(
          screen(tester),
          initial: const TimeOfDay(hour: 8, minute: 0),
        ),
      ),
    ),
    'date wheel': (
      AppRoutes.today,
      (tester) async => unawaited(
        showDateWheel(
          screen(tester),
          initial: today,
          first: today,
          last: today.add(const Duration(days: 30)),
        ),
      ),
    ),
  };

  group('sheets and dialogs', () {
    for (final MapEntry(key: name, value: (path, open)) in overlays.entries) {
      for (final theme in themes) {
        testWidgets('$name meets the guidelines in $theme', (tester) async {
          final handle = tester.ensureSemantics();
          await pumpAt(tester, path, theme: theme);
          await open(tester);
          await tester.pumpAndSettle();

          await expectGuidelines(tester);
          handle.dispose();
        });
      }

      testWidgets('$name fits text at 200%', (tester) async {
        final handle = tester.ensureSemantics();
        useLargeText(tester);
        await pumpAt(tester, path);
        await open(tester);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        handle.dispose();
      });
    }
  });
}
