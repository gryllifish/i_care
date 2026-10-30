import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_shadows.dart';
import 'package:i_care/core/theme/app_spacing.dart';

/// A rounded, softly raised surface; tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.color,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.raised = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Defaults to the palette's surface.
  final Color? color;
  final EdgeInsetsGeometry padding;

  /// Whether it casts a shadow; flat cards sit on tinted backgrounds.
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final content = Padding(padding: padding, child: child);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: raised ? AppShadows.card(context.colors) : null,
      ),
      child: Material(
        color: color ?? context.colors.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        // Each card is its own node for screen readers, never merged with
        // the cards around it.
        child: onTap == null
            ? Semantics(container: true, child: content)
            : Semantics(
                button: true,
                child: InkWell(onTap: onTap, child: content),
              ),
      ),
    );
  }
}
