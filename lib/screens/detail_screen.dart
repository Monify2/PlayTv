import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import '../services/ad_service.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';
import '../widgets/icon_style.dart';
import '../widgets/reward_ad_dialog.dart';
import '../widgets/download_quality_dialog.dart';
import 'player_screen.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final PlayTitle? fallback;

  const DetailScreen({super.key, required this.id, this.fallback});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final api = ApiService();

  Map<String, dynamic>? data;
  bool loading = true;
  bool saved = false;
  int selectedSeason = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = await api.title(widget.id);

      if (mounted) {
        setState(() {
          data = result;
          loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          data = null;
          loading = false;
        });
      }
    }
  }

  Future<void> toggle() async {
    try {
      if (saved) {
        await api.removeWatchlist(widget.id);
      } else {
        await api.addWatchlist(widget.id);
      }

      if (mounted) {
        setState(() {
          saved = !saved;
        });
      }
    } catch (_) {}
  }

  Future<void> download({String? episodeId, required String name}) async {
    try {
      final me = await api.me();
      final premium = _isPremiumAccount(me);

      if (!mounted) return;
      final quality = await showDialog<String>(
        context: context,
        builder: (_) => DownloadQualityDialog(premium: premium),
      );

      if (quality == null) return;

      final highQuality = _isHighQuality(quality);
      var rewardCompleted = false;

      if (!premium && highQuality) {
        final ads = await AdService().placements();
        AdPlacement? reward;

        for (final placement in ads) {
          if (placement.rewardDownload) {
            reward = placement;
            break;
          }
        }

        if (reward == null) {
          throw Exception('High-quality downloads require a rewarded ad, but no reward ad is available right now.');
        }

        rewardCompleted =
            await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (_) => RewardAdDialog(
                placement: reward!,
                title: 'Unlock high-quality download',
                message: 'Complete this rewarded ad to unlock the selected quality for this download.',
              ),
            ) ??
            false;

        if (!rewardCompleted) return;
      }

      final result = await DownloadService().downloadOffline(
        titleId: widget.id,
        episodeId: episodeId,
        fileName: name,
        rewardAdCompleted: rewardCompleted,
        quality: _backendQuality(quality),
        onProgress: (_) {},
      );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download saved for offline use.'),
            ),
          );
        }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

    bool _isPremiumAccount(dynamic me) {
      if (me is! Map) return false;

      final entitlement = me['entitlement'];
      if (entitlement is Map && entitlement['is_premium'] == true) {
        return true;
      }

      final subscription = me['subscription'];
      if (subscription is Map) {
        final status = '${subscription['status'] ?? ''}''.toLowerCase();
        return (status == 'active' || status == 'trialing') &&
        final status = '${subscription['status'] ?? ''}'.toLowerCase();
      }

      return false;
    }

    bool _isHighQuality(String quality) {
      return quality == 'Full HD' || quality == '4K';
    }

    String _backendQuality(String quality) {
      switch (quality) {
        case 'Full HD':
          return 'Full HD';
        case '4K':
          return '4K';
        default:
          return quality;
      }
    }

  @override
  Widget build(BuildContext context) {
    final title = data?['title'] is Map
        ? PlayTitle.fromJson(Map<String, dynamic>.from(data!['title']))
        : widget.fallback;

    if (loading && title == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: PlayTvColors.green),
        ),
      );
    }

    if (title == null) {
      return const Scaffold(body: Center(child: Text('Title unavailable')));
    }

    final seasons = (data?['seasons'] as List?) ?? const [];
    final people = (data?['people'] as List?) ?? const [];
    final genres = (data?['genres'] as List?) ?? const [];

    final isSeries = title.type == 'series';

    final safeSeason = seasons.isEmpty
        ? 0
        : selectedSeason.clamp(0, seasons.length - 1);

    final season = seasons.isNotEmpty
        ? Map<String, dynamic>.from(seasons[safeSeason])
        : <String, dynamic>{};

    final episodes = (season['episodes'] as List?) ?? const [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 270,
            pinned: true,
            backgroundColor: PlayTvColors.background,
            actions: [
              IconButton(
                onPressed: toggle,
                tooltip: 'My List',
                icon: PlayTvIcon(
                  saved ? Icons.bookmark : Icons.bookmark_border,
                  active: saved,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (title.backdrop != null)
                    CachedNetworkImage(
                      imageUrl: title.backdrop!,
                      fit: BoxFit.cover,
                    ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, PlayTvColors.background],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(title.releaseDate?.split('-').first ?? '—'),
                      const SizedBox(width: 12),
                      if (title.rating != null) Text(title.rating!),
                      const SizedBox(width: 12),
                      const PlayTvIcon(
                        Icons.star_rounded,
                        color: PlayTvColors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(title.score.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final genre in genres)
                        _Tag('${genre is Map ? (genre['name'] ?? '') : genre}'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerScreen(
                                  titleId: title.id,
                                  title: title.name,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('PLAY'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: toggle,
                        icon: PlayTvIcon(
                          saved ? Icons.bookmark : Icons.bookmark_border,
                          active: saved,
                        ),
                        label: const Text('MY LIST'),
                      ),
                    ],
                  ),
                  if (!isSeries) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          download(name: title.name);
                        },
                        icon: const PlayTvIcon(Icons.download_outlined),
                        label: const Text('DOWNLOAD'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    title.synopsis ?? 'No synopsis available.',
                    style: const TextStyle(
                      color: PlayTvColors.muted,
                      height: 1.45,
                    ),
                  ),
                  if (isSeries && seasons.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Season',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: safeSeason,
                      dropdownColor: PlayTvColors.surface,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.tv_rounded),
                        labelText: 'Select preferred season',
                      ),
                      items: [
                        for (var index = 0; index < seasons.length; index++)
                          DropdownMenuItem(
                            value: index,
                            child: Text(
                              '${seasons[index]['name'] ?? 'Season ${index + 1}'}',
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSeason = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    for (final episode in episodes)
                      _EpisodeTile(
                        titleId: title.id,
                        seriesName: title.name,
                        episode: Map<String, dynamic>.from(episode),
                        onDownload: () {
                          download(
                            episodeId: '${episode['id']}',
                            name:
                                '${title.name}_S${season['season_number'] ?? safeSeason + 1}_E${episode['episode_number'] ?? 0}',
                          );
                        },
                      ),
                  ],
                  if (people.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Cast & Crew',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 112,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: people.length,
                        separatorBuilder: (_, index) {
                          return const SizedBox(width: 12);
                        },
                        itemBuilder: (_, index) {
                          final person = Map<String, dynamic>.from(
                            people[index],
                          );

                          final profile = person['profile_url']?.toString();

                          return SizedBox(
                            width: 75,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: profile != null
                                      ? NetworkImage(profile)
                                      : null,
                                  child: profile == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${person['name'] ?? ''}',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final String titleId;
  final String seriesName;
  final Map<String, dynamic> episode;
  final VoidCallback onDownload;

  const _EpisodeTile({
    required this.titleId,
    required this.seriesName,
    required this.episode,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final episodeNumber = '${episode['episode_number'] ?? ''}';
    final episodeName = '${episode['name'] ?? 'Episode'}';
    final synopsis = '${episode['synopsis'] ?? episode['overview'] ?? ''}'.trim();
    final runtime = episode['runtime']?.toString();
    final airDate = episode['air_date']?.toString();
    final rating = episode['vote_average'] ?? episode['rating'];
    final progress = _progress(episode);
    final still = episode['still_url'] ?? episode['still_path'] ?? episode['thumbnail_url'];

    return Card(
      color: PlayTvColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlayerScreen(
                titleId: titleId,
                title: '$seriesName • $episodeName',
                episodeId: '${episode['id']}',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 128,
                height: 76,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: still != null && '$still'.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: '$still',
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _episodePlaceholder(),
                        )
                      : _episodePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'E$episodeNumber · $episodeName',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Download episode',
                          onPressed: onDownload,
                          icon: const PlayTvIcon(Icons.download_outlined),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        if (runtime != null && runtime.isNotEmpty)
                          _EpisodeMeta(Icons.schedule_rounded, '$runtime min'),
                        if (airDate != null && airDate.isNotEmpty)
                          _EpisodeMeta(Icons.calendar_today_rounded, airDate),
                        if (rating != null)
                          _EpisodeMeta(Icons.star_rounded, _ratingText(rating)),
                      ],
                    ),
                    if (synopsis.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        synopsis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PlayTvColors.muted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (progress > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          color: PlayTvColors.green,
                          backgroundColor: PlayTvColors.line,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _episodePlaceholder() => const ColoredBox(
        color: PlayTvColors.surface2,
        child: Center(
          child: PlayTvIcon(Icons.play_circle_outline_rounded, size: 32),
        ),
      );

  double _progress(Map<String, dynamic> value) {
    final raw = value['progress'] ?? value['watch_progress'] ?? 0;
    final number = double.tryParse('$raw') ?? 0;
    return number > 1 ? (number / 100).clamp(0, 1) : number.clamp(0, 1);
  }

  String _ratingText(dynamic value) =>
      double.tryParse('$value')?.toStringAsFixed(1) ?? '$value';
}

class _EpisodeMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EpisodeMeta(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayTvIcon(icon, size: 13, color: PlayTvColors.muted),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: PlayTvColors.muted, fontSize: 11),
          ),
        ],
      );
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag(this.text);

    final entitlement = me['entitlement'];
    if (entitlement is Map && entitlement['is_premium'] == true) return true;

    final subscription = me['subscription'];
    if (subscription is Map) {
      final status = '${subscription['status'] ?? ''}'.toLowerCase();
      return (status == 'active' || status == 'trialing') &&
          subscription['plan'] != null;
    }

    return false;
  }
      case 'Full HD':
        return 'Full HD';
      case '4K':
        return '4K';
      default:
        return quality;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text, style: const TextStyle(fontSize: 10)));
  }
}
