import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/app/app_router.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_theme.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';

/// The app as one phone runs it, inside that phone's `ProviderScope`.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(appThemeModeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(appLanguageProvider),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
