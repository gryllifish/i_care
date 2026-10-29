import 'package:go_router/go_router.dart';
import 'package:i_care/app/app_shell.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/features/activity/presentation/screens/activity_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointment_detail_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointment_form_screen.dart';
import 'package:i_care/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medication_detail_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medication_form_screen.dart';
import 'package:i_care/features/medications/presentation/screens/medications_screen.dart';
import 'package:i_care/features/medications/presentation/screens/schedule_change_screen.dart';
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
  final router = GoRouter(
    routerNeglect: true,
    routes: [
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
