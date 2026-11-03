import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/app/app.dart';
import 'package:i_care/app/phone_frame.dart';
import 'package:i_care/app/simulated_device.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/theme/app_theme.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';

/// Shows every simulated phone side by side when there is room (the web
/// demo on a desktop), or the first phone alone on a real phone.
class DemoShell extends StatelessWidget {
  const DemoShell({required this.devices, super.key});

  final List<SimulatedDevice> devices;

  static const double _gap = AppSpacing.xxxl;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LayoutBuilder(
        builder: (context, constraints) {
          final sideBySideWidth =
              devices.length * PhoneFrame.width + (devices.length + 1) * _gap;
          if (constraints.maxWidth < sideBySideWidth) {
            return _DeviceScope(device: devices.first, child: const App());
          }
          return _SideBySide(devices: devices, height: constraints.maxHeight);
        },
      ),
    );
  }
}

class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.devices, required this.height});

  final List<SimulatedDevice> devices;
  final double height;

  /// Room left for the hint above and the controls below each phone.
  static const _chromeHeight = 180.0;
  static const _hintWidth = 640.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.backdrop,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          spacing: AppSpacing.xl,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _hintWidth),
              child: Text(
                context.l10n.demoHint,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: DemoShell._gap,
              children: [
                for (final (index, device) in devices.indexed)
                  _DeviceScope(
                    device: device,
                    child: Column(
                      spacing: AppSpacing.md,
                      children: [
                        _PhoneTitle(number: index + 1),
                        PhoneFrame(
                          maxHeight: height - _chromeHeight,
                          child: const App(),
                        ),
                        const _NetworkSwitch(),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceScope extends StatelessWidget {
  const _DeviceScope({required this.device, required this.child});

  final SimulatedDevice device;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      UncontrolledProviderScope(container: device.container, child: child);
}

/// Whose phone this is, or its number while it belongs to nobody (the
/// demo started without data).
class _PhoneTitle extends ConsumerWidget {
  const _PhoneTitle({required this.number});

  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final member = ref.watch(currentMemberProvider);
    return Text(
      member == null ? l10n.phoneNumber(number) : l10n.phoneOf(member.name),
      style: AppTextStyles.title,
    );
  }
}

/// Turns this phone's simulated network on and off.
class _NetworkSwitch extends ConsumerWidget {
  const _NetworkSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(networkEnabledProvider);
    final l10n = context.l10n;
    return SizedBox(
      width: PhoneFrame.width,
      child: SwitchListTile(
        value: enabled,
        onChanged: (_) => ref.read(networkEnabledProvider.notifier).toggle(),
        secondary: Icon(enabled ? Icons.wifi : Icons.wifi_off),
        title: Text(
          enabled ? l10n.networkOn : l10n.networkOff,
          style: AppTextStyles.label,
        ),
      ),
    );
  }
}
