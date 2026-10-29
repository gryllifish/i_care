import 'package:go_router/go_router.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Lives in `app/` (not `core/`) because it imports every feature's screens;
/// `core` must never depend on features.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.today,
        builder: (context, state) => const TodayScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
