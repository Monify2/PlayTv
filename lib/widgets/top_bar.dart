import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'brand.dart';
import 'icon_style.dart';

class TopBar extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onProfile;
  const TopBar({super.key, this.onSearch, this.onProfile});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.black,
      border: Border(bottom: BorderSide(color: PlayTvColors.line)),
    ),
    padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
    child: Row(
      children: [
        const PlayTvBrand(compact: true),
        const Spacer(),
        IconButton(
          onPressed: onSearch,
          tooltip: 'Search',
          icon: const PlayTvIcon(Icons.search_rounded, size: 22),
        ),
        IconButton(
          onPressed: onProfile,
          tooltip: 'Menu',
          icon: const PlayTvIcon(Icons.person_outline_rounded, size: 22),
        ),
      ],
    ),
  );
}
