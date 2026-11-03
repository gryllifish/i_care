import 'package:flutter/foundation.dart';
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
import 'package:i_care/features/settings/presentation/screens/removed_screen.dart';
import 'package:i_care/features/settings/presentation/screens/settings_screen.dart';
import 'package:i_care/features/settings/presentation/screens/welcome_screen.dart';
import 'package:i_care/features/tasks/presentation/screens/task_form_screen.dart';
import 'package:i_care/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
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
      GoRoute(
        path: AppRoutes.join,
        builder: (context, state) => const JoinScreen(),
      ),
      GoRoute(
        path: AppRoutes.createCircle,
        builder: (context, state) => const CreateCircleScreen(),
      ),
      GoRoute(
        path: AppRoutes.removed,
        builder: (context, state) => const RemovedScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      // Outside the shell, so they cover the tab bar.
      GoRoute(
        path: AppRoutes.emergency,
        builder: (context, state) => const EmergencyCardScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.editEmergency,
            builder: (context, state) => const ProfileFormScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.handoff,
        builder: (context, state) => const HandoffScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.medications,
                builder: (context, state) => const MedicationsScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.newMedication,
                    builder: (context, state) => const MedicationFormScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.medication,
                    builder: (context, state) => MedicationDetailScreen(
                      medicationId: _idOf(state),
                    ),
                    routes: [
                      GoRoute(
                        path: AppRoutes.editMedication,
                        builder: (context, state) => MedicationFormScreen(
                          medicationId: _idOf(state),
                        ),
                      ),
                      GoRoute(
                        path: AppRoutes.changeSchedule,
                        builder: (context, state) => ScheduleChangeScreen(
                          medicationId: _idOf(state),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.newTask,
                    builder: (context, state) => const TaskFormScreen(),
                  ),
                  GoRoute(
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
              GoRoute(
                path: AppRoutes.appointments,
                builder: (context, state) => const AppointmentsScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.newAppointment,
                    builder: (context, state) => const AppointmentFormScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.appointment,
                    builder: (context, state) => AppointmentDetailScreen(
                      appointmentId: _idOf(state),
                    ),
                    routes: [
                      GoRoute(
                        path: AppRoutes.editAppointment,
                        builder: (context, state) => AppointmentFormScreen(
                          appointmentId: _idOf(state),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
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
