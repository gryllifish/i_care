import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/app/app_shell.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/features/activity/presentation/screens/activity_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointment_detail_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointment_form_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/emergency/presentation/screens/emergency_card_screen.dart';
import 'package:i_care/features/emergency/presentation/screens/profile_form_screen.dart';
import 'package:i_care/features/handoff/presentation/screens/handoff_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medication_detail_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medication_form_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medications_screen.dart';
import 'package:i_care/features/medications/presentation/screens/schedule_change_screen.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/features/settings/presentation/screens/create_circle_screen.dart';
import 'package:i_care/features/settings/presentation/screens/join_screen.dart';
import 'package:i_care/features/settings/presentation/screens/reasons_screen.dart';
import 'package:i_care/features/settings/presentation/screens/removed_screen.dart';
import 'package:i_care/features/settings/presentation/screens/settings_screen.dart';
import 'package:i_care/features/settings/presentation/screens/welcome_screen.dart';
import 'package:i_care/features/tasks/presentation/screens/task_form_screen.dart';
import 'package:i_care/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
import 'package:i_care/shared/widgets/content_width.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Lives in `app/` (not `core/`) because it imports every feature's screens;
/// `core` must never depend on features.
///
/// `routerNeglect` keeps navigation out of the browser history: the web
/// demo runs two phones, each with its own router, on one page, and the
/// browser's back button must not move both at once.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // The router lives as long as the app, so it follows where this phone
  // stands through a listenable instead of being rebuilt.
  _Gate gate() => (
    joined: ref.read(deviceMembershipProvider) != null,
    isMember: ref.read(syncStatusProvider).value?.isMember ?? true,
    welcomeSeen: ref.read(welcomeSeenProvider),
    helper: ref.read(currentMemberProvider)?.role == MemberRole.helper,
  );
  final stand = ValueNotifier(gate());
  void update() => stand.value = gate();
  ref
    ..listen(deviceMembershipProvider, (_, _) => update())
    ..listen(syncStatusProvider, (_, _) => update())
    ..listen(welcomeSeenProvider, (_, _) => update())
    ..listen(currentMemberProvider, (_, _) => update())
    ..onDispose(stand.dispose);

  final router = GoRouter(
    routerNeglect: true,
    refreshListenable: stand,
    redirect: (context, state) {
      // A phone that belongs to nobody joins first; one taken out of the
      // circle says so; then the welcome, once.
      final gate = stand.value;
      final required = switch (gate) {
        (joined: false, isMember: _, welcomeSeen: _, helper: _) =>
          AppRoutes.join,
        (joined: true, isMember: false, welcomeSeen: _, helper: _) =>
          AppRoutes.removed,
        (joined: true, isMember: true, welcomeSeen: false, helper: _) =>
          AppRoutes.welcome,
        _ => null,
      };
      final at = state.matchedLocation;
      // Creating a circle is part of joining one.
      final atRequired =
          at == required ||
          (required == AppRoutes.join && at == AppRoutes.createCircle);
      if (required != null) return atRequired ? null : required;
      const gates = {
        AppRoutes.join,
        AppRoutes.createCircle,
        AppRoutes.removed,
        AppRoutes.welcome,
      };
      if (gates.contains(at)) return AppRoutes.today;
      // A helper's app is today's care only (`docs/roles.md`).
      const helpersAway = [
        AppRoutes.medications,
        AppRoutes.tasks,
        AppRoutes.appointments,
        AppRoutes.activity,
      ];
      return gate.helper && helpersAway.any(at.startsWith)
          ? AppRoutes.today
          : null;
    },
    routes: [
      _route(
        path: AppRoutes.join,
        builder: (context, state) => const ContentWidth(child: JoinScreen()),
      ),
      _route(
        path: AppRoutes.createCircle,
        builder: (context, state) =>
            const ContentWidth(child: CreateCircleScreen()),
      ),
      _route(
        path: AppRoutes.removed,
        builder: (context, state) => const ContentWidth(child: RemovedScreen()),
      ),
      _route(
        path: AppRoutes.welcome,
        builder: (context, state) => const ContentWidth(child: WelcomeScreen()),
      ),
      _route(
        path: AppRoutes.settings,
        builder: (context, state) =>
            const ContentWidth(child: SettingsScreen()),
      ),
      _route(
        path: AppRoutes.reasons,
        builder: (context, state) => const ContentWidth(child: ReasonsScreen()),
      ),
      // Outside the shell, so they cover the tab bar.
      _route(
        path: AppRoutes.emergency,
        builder: (context, state) =>
            const ContentWidth(child: EmergencyCardScreen()),
        routes: [
          _route(
            path: AppRoutes.editEmergency,
            builder: (context, state) =>
                const ContentWidth(child: ProfileFormScreen()),
          ),
        ],
      ),
      _route(
        path: AppRoutes.handoff,
        builder: (context, state) => const ContentWidth(child: HandoffScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              _route(
                path: AppRoutes.today,
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              _route(
                path: AppRoutes.medications,
                builder: (context, state) => const MedicationsScreen(),
                routes: [
                  _route(
                    path: AppRoutes.newMedication,
                    builder: (context, state) => const MedicationFormScreen(),
                  ),
                  _route(
                    path: AppRoutes.medication,
                    builder: (context, state) =>
                        MedicationDetailScreen(medicationId: _idOf(state)),
                    routes: [
                      _route(
                        path: AppRoutes.editMedication,
                        builder: (context, state) =>
                            MedicationFormScreen(medicationId: _idOf(state)),
                      ),
                      _route(
                        path: AppRoutes.changeSchedule,
                        builder: (context, state) =>
                            ScheduleChangeScreen(medicationId: _idOf(state)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              _route(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksScreen(),
                routes: [
                  _route(
                    path: AppRoutes.newTask,
                    builder: (context, state) => const TaskFormScreen(),
                  ),
                  _route(
                    path: AppRoutes.editTask,
                    builder: (context, state) =>
                        TaskFormScreen(taskId: _idOf(state)),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              _route(
                path: AppRoutes.appointments,
                builder: (context, state) => const AppointmentsScreen(),
                routes: [
                  _route(
                    path: AppRoutes.newAppointment,
                    builder: (context, state) => const AppointmentFormScreen(),
                  ),
                  _route(
                    path: AppRoutes.appointment,
                    builder: (context, state) =>
                        AppointmentDetailScreen(appointmentId: _idOf(state)),
                    routes: [
                      _route(
                        path: AppRoutes.editAppointment,
                        builder: (context, state) =>
                            AppointmentFormScreen(appointmentId: _idOf(state)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              _route(
                path: AppRoutes.activity,
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

/// The path only matches with a non-empty id, so it is always present.
String _idOf(GoRouterState state) =>
    state.pathParameters[AppRoutes.idParam] ?? '';

/// Where this phone stands: whether it joined a circle, is still in it,
/// has seen the welcome, and is a helper's.
typedef _Gate = ({bool joined, bool isMember, bool welcomeSeen, bool helper});

/// A route whose page is always a [MaterialPage], so pushed screens slide
/// in and, on iOS, close with the back swipe.
///
/// go_router picks the page type by looking for a `MaterialApp` above the
/// router, but it looks for the one in `package:material_ui`, not the one
/// in `package:flutter/material.dart` this app uses. Not finding it, it
/// falls back to pages with no transition and no back swipe.
GoRoute _route({
  required String path,
  required GoRouterWidgetBuilder builder,
  List<RouteBase> routes = const [],
}) => GoRoute(
  path: path,
  routes: routes,
  pageBuilder: (context, state) => MaterialPage<void>(
    key: state.pageKey,
    name: state.name ?? state.path,
    restorationId: state.pageKey.value,
    child: builder(context, state),
  ),
);
