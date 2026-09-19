import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import 'movie_card.dart';
import 'icon_style.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<PlayTitle> items;
  final void Function(PlayTitle) onTap;
  final VoidCallback? onMore;
  const ContentRow({
    super.key,
    required this.title,
    required this.items,
    required this.onTap,
    this.onMore,
  });
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 10, 10),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (onMore != null)
                IconButton(
                  onPressed: onMore,
                  tooltip: 'See all',
                  icon: const PlayTvIcon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: PlayTvColors.muted,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 225,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = items[i];
              return MovieCard(item: item, onTap: () => onTap(item));
            },
          ),
        ),
      ],
    );
  }
}
