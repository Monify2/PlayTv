import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import 'icon_style.dart';

class MovieCard extends StatelessWidget {
  final PlayTitle item;
  final VoidCallback onTap;
  final double width;
  const MovieCard({
    super.key,
    required this.item,
    required this.onTap,
    this.width = 125,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: .68,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: item.poster == null
                        ? Container(
                            color: PlayTvColors.surface2,
                            child: const Center(
                              child: PlayTvIcon(Icons.movie_outlined, size: 30),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: item.poster!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorWidget: (_, __, ___) => Container(
                              color: PlayTvColors.surface2,
                              child: const Center(
                                child: PlayTvIcon(
                                  Icons.broken_image_outlined,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .62),
                        shape: BoxShape.circle,
                      ),
                      child: const MoreIconButton(),
                    ),
                  ),
                  if (item.premium)
                    Positioned(
                      left: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: PlayTvColors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            if (item.releaseDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  item.releaseDate!.length >= 4
                      ? item.releaseDate!.substring(0, 4)
                      : item.releaseDate!,
                  style: const TextStyle(
                    color: PlayTvColors.muted,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
