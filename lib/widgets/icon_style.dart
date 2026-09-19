import 'package:flutter/material.dart';
import '../core/theme.dart';

/// PlayTv's shared icon language: thin, simple, monochrome icons on graphite,
/// with the electric-green accent reserved for active/primary actions.
class PlayTvIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool active;
  final Color? color;
  final String? semanticLabel;
  const PlayTvIcon(this.icon, {super.key, this.size = 21, this.active = false, this.color, this.semanticLabel});

  @override
  Widget build(BuildContext context) => Icon(
        icon,
        size: size,
        color: color ?? (active ? PlayTvColors.green : PlayTvColors.icon),
        semanticLabel: semanticLabel,
      );
}

class MoreIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const MoreIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        tooltip: 'More',
        visualDensity: VisualDensity.compact,
        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
        iconSize: 22,
        icon: const PlayTvIcon(Icons.more_horiz_rounded, size: 22),
      );
}
