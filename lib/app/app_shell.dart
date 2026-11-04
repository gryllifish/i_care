import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/constants/app_layout.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/shared/widgets/content_width.dart';

/// The tabs around every screen: at the bottom on a phone, at the side on
/// a wide screen ([AppLayout.sideNavigationMinWidth]), with the content in
/// a readable column. Each tab keeps its own navigation stack and scroll
/// position.
///
/// The width is the space this app has, not the window's: in the demo's
/// phone frames it stays a phone.
class AppShell extends ConsumerWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ContentWidth(child: shell);
    // A helper's app is Today only (`docs/roles.md`): no tabs.
    if (ref.watch(currentMemberProvider)?.role == MemberRole.helper) {
      return Scaffold(body: content);
    }
    final tabs = _tabs(context.l10n);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppLayout.sideNavigationMinWidth) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: shell.currentIndex,
                  onDestinationSelected: _go,
                  destinations: [
                    for (final tab in tabs)
                      NavigationRailDestination(
                        icon: Icon(tab.icon),
                        selectedIcon: Icon(tab.selectedIcon),
                        label: Text(tab.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: content),
              ],
            ),
          );
        }
        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _go,
            destinations: [
              for (final tab in tabs)
                NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                  label: tab.label,
                ),
            ],
          ),
        );
      },
    );
  }

  void _go(int index) => shell.goBranch(
    index,
    // Tapping the current tab again returns to its first page.
    initialLocation: index == shell.currentIndex,
  );

  static List<({IconData icon, IconData selectedIcon, String label})> _tabs(
    AppLocalizations l10n,
  ) => [
    (
      icon: Icons.today_outlined,
      selectedIcon: Icons.today,
      label: l10n.navToday,
    ),
    (
      icon: Icons.medication_outlined,
      selectedIcon: Icons.medication,
      label: l10n.tabMedications,
    ),
    (
      icon: Icons.volunteer_activism_outlined,
      selectedIcon: Icons.volunteer_activism,
      label: l10n.navTasks,
    ),
    (
      icon: Icons.event_outlined,
      selectedIcon: Icons.event,
      label: l10n.tabAppointments,
    ),
    (
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: l10n.navActivity,
    ),
  ];
}
