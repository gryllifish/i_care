import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/app/app_shell.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/features/activity/presentation/screens/activity_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointment_detail_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointment_form_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:i_care/features/emergency/presentation/screens/emergency_card_screen.dart';
import 'package:i_care/features/emergency/presentation/screens/profile_form_screen.dart';
import 'package:i_care/features/handoff/presentation/screens/handoff_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medication_detail_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medication_form_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medications_screen.dart';
import 'package:i_care/features/medications/presentation/screens/schedule_change_screen.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/features/settings/presentation/screens/settings_screen.dart';
import 'package:i_care/features/settings/presentation/screens/welcome_screen.dart';
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
  // The router lives as long as the app, so it follows the welcome flag
  // through a listenable instead of being rebuilt.
  final welcomeSeen = ValueNotifier(ref.read(welcomeSeenProvider));
  ref
    ..listen(welcomeSeenProvider, (_, seen) => welcomeSeen.value = seen)
    ..onDispose(welcomeSeen.dispose);

  final router = GoRouter(
    routerNeglect: true,
    refreshListenable: welcomeSeen,
    redirect: (context, state) {
      final atWelcome = state.matchedLocation == AppRoutes.welcome;
      if (!welcomeSeen.value) return atWelcome ? null : AppRoutes.welcome;
      return atWelcome ? AppRoutes.today : null;
    },
    routes: [
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
