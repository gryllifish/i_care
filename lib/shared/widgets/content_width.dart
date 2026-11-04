import 'package:flutter/material.dart';
import 'package:i_care/core/constants/app_layout.dart';

/// Keeps [child] in a centered column no wider than
/// [AppLayout.contentMaxWidth], over the app's background: a screen
/// designed for phones, readable on a wide one. On a phone it changes
/// nothing.
class ContentWidth extends StatelessWidget {
  const ContentWidth({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.contentMaxWidth),
        child: child,
      ),
    ),
  );
}
