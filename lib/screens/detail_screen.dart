import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/title.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';
import '../widgets/icon_style.dart';
import 'player_screen.dart';

class DetailScreen extends StatefulWidget { final String id; final PlayTitle? fallback; const DetailScreen({super.key, required this.id, this.fallback}); @override State<DetailScreen> createState() => _DetailScreenState(); }
class _DetailScreenState extends State<DetailScreen> {
  final api = ApiService(); Map<String, dynamic>? data; bool loading = true; bool saved = false;
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    try {
      final d = await api.title(widget.id);
      if (mounted) setState(() { data = d; loading = false; });
    } catch (e) {
      if (mounted) setState(() { data = null; loading = false; });
    }
  }
  Future<void> toggle() async { try { if (saved) await api.removeWatchlist(widget.id); else await api.addWatchlist(widget.id); if (mounted) setState(() => saved = !saved); } catch (_) {} }
  @override Widget build(BuildContext context) {
    final title = data?['title'] is Map ? PlayTitle.fromJson(Map<String, dynamic>.from(data!['title'])) : widget.fallback;
    if (loading && title == null) return const Scaffold(body: Center(child: CircularProgressIndicator(color: PlayTvColors.green)));
    if (title == null) return const Scaffold(body: Center(child: Text('Title unavailable')));
    final seasons = (data?['seasons'] as List?) ?? const [];
    final people = (data?['people'] as List?) ?? const [];
    final genres = (data?['genres'] as List?) ?? const [];
    return Scaffold(body: CustomScrollView(slivers: [
      SliverAppBar(expandedHeight: 270, pinned: true, backgroundColor: PlayTvColors.background, actions: [IconButton(onPressed: toggle, tooltip: 'My List', icon: PlayTvIcon(saved ? Icons.bookmark : Icons.bookmark_border, active: saved))], flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [if (title.backdrop != null) CachedNetworkImage(imageUrl: title.backdrop!, fit: BoxFit.cover), const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, PlayTvColors.background])))]))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16, 2, 16, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8), Row(children: [Text(title.releaseDate?.split('-').first ?? '—'), const SizedBox(width: 12), if (title.rating != null) Text(title.rating!), const SizedBox(width: 12), const PlayTvIcon(Icons.star_rounded, color: PlayTvColors.green, size: 16), const SizedBox(width: 3), Text(title.score.toStringAsFixed(1))]),
        const SizedBox(height: 14), Wrap(spacing: 6, children: [for (final g in genres) _Tag('${g is Map ? (g['name'] ?? '') : g}')]),
        const SizedBox(height: 18), Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(titleId: title.id, title: title.name))), icon: const Icon(Icons.play_arrow_rounded), label: const Text('PLAY'))), const SizedBox(width: 8), OutlinedButton.icon(onPressed: toggle, icon: PlayTvIcon(saved ? Icons.bookmark : Icons.bookmark_border, active: saved), label: const Text('MY LIST'))]),
        const SizedBox(height: 8), SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () async { try { await DownloadService().create(titleId: title.id); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download added.'))); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } }, icon: const PlayTvIcon(Icons.download_outlined), label: const Text('DOWNLOAD'))),
        const SizedBox(height: 18), Text(title.synopsis ?? 'No synopsis available.', style: const TextStyle(color: PlayTvColors.muted, height: 1.45)),
        if (seasons.isNotEmpty) ...[const SizedBox(height: 24), const Text('Seasons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 8), for (final s in seasons) _SeasonCard(s: Map<String, dynamic>.from(s))],
        if (people.isNotEmpty) ...[const SizedBox(height: 24), const Text('Cast & Crew', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 10), SizedBox(height: 112, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: people.length, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, i) { final p = Map<String, dynamic>.from(people[i]); return SizedBox(width: 75, child: Column(children: [CircleAvatar(radius: 30, backgroundImage: p['profile_url'] != null ? NetworkImage('${p['profile_url']}') : null, child: p['profile_url'] == null ? const Icon(Icons.person) : null), const SizedBox(height: 6), Text('${p['name'] ?? ''}', maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))])); }))],
      ])),
    ]));
  }
}
class _Tag extends StatelessWidget { final String text; const _Tag(this.text); @override Widget build(BuildContext context) => Chip(label: Text(text, style: const TextStyle(fontSize: 10))); }
class _SeasonCard extends StatelessWidget { final Map<String, dynamic> s; const _SeasonCard({required this.s}); @override Widget build(BuildContext context) { final episodes = (s['episodes'] as List?) ?? const []; return Card(color: PlayTvColors.surface, child: ExpansionTile(title: Text('${s['name'] ?? 'Season'}'), subtitle: Text('${episodes.length} episodes', style: const TextStyle(color: PlayTvColors.muted, fontSize: 11)), children: [for (final e in episodes) ListTile(leading: const PlayTvIcon(Icons.play_circle_outline_rounded, size: 29), title: Text('${e['episode_number'] ?? ''}. ${e['name'] ?? 'Episode'}'), subtitle: Text('${e['runtime'] ?? ''} min'), onTap: () {})])); } }
