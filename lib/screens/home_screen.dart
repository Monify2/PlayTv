import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/title.dart';
import '../services/api_service.dart';
import '../services/supabase_service.dart';
import '../widgets/content_row.dart';
import '../widgets/top_bar.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenMenu;
  const HomeScreen({super.key, this.onOpenSearch, this.onOpenMenu});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  bool loading = true;
  String? error;
  List<PlayTitle> featured = [], trending = [], newReleases = [], movies = [], series = [];
  List<Progress> progress = [];

  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    if (!SupabaseService.isReady) {
      if (mounted) setState(() {
        error = 'PlayTv backend is not configured.';
        loading = false;
      });
      return;
    }
    try {
      final data = await api.home();
      final p = await api.progress();
      List<PlayTitle> parse(String key) => ((data[key] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => PlayTitle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      if (mounted) {
        setState(() {
          featured = parse('featured');
          trending = parse('trending');
          newReleases = parse('new_releases');
          movies = parse('movies');
          series = parse('series');
          progress = p;
          error = null;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString().replaceFirst('Exception: ', '');
          loading = false;
        });
      }
    }
  }

  void open(PlayTitle t) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(id: t.id, fallback: t)));

  @override Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: load,
        color: PlayTvColors.green,
        backgroundColor: PlayTvColors.surface,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: TopBar(onSearch: widget.onOpenSearch, onProfile: widget.onOpenMenu)),
          if (loading) const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: PlayTvColors.green)))
          else if (error != null) SliverFillRemaining(child: _ErrorView(error!, onRetry: load))
          else SliverList(delegate: SliverChildListDelegate([
            _Hero(items: featured.isNotEmpty ? featured : (trending.isNotEmpty ? trending : movies), onTap: open),
            if (progress.isNotEmpty) _Continue(items: progress.where((e) => e.title != null).toList(), onTap: (p) => open(p.title!)),
            ContentRow(title: 'Popular', items: trending, onTap: open),
            ContentRow(title: 'New Releases', items: newReleases, onTap: open),
            ContentRow(title: 'Movies', items: movies, onTap: open),
            ContentRow(title: 'Series', items: series, onTap: open),
            const SizedBox(height: 22),
          ])),
        ]),
      );
}

class _Hero extends StatelessWidget {
  final List<PlayTitle> items; final void Function(PlayTitle) onTap;
  const _Hero({required this.items, required this.onTap});
  @override Widget build(BuildContext context) {
    if (items.isEmpty) return Container(height: 220, margin: const EdgeInsets.all(14), decoration: BoxDecoration(color: PlayTvColors.surface, borderRadius: BorderRadius.circular(14)), child: const Center(child: Text('Your catalogue is ready for content.')));
    final t = items.first;
    return Container(height: 245, margin: const EdgeInsets.fromLTRB(14, 12, 14, 0), clipBehavior: Clip.antiAlias, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: PlayTvColors.surface), child: Stack(fit: StackFit.expand, children: [
      if (t.backdrop != null) Image.network(t.backdrop!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: PlayTvColors.surface2)) else Container(color: PlayTvColors.surface2),
      const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x11111A18), Color(0xEE0D1110)]))),
      Positioned(left: 16, right: 16, bottom: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: PlayTvColors.green, borderRadius: BorderRadius.circular(5)), child: Text(t.premium ? 'PREMIUM' : 'FEATURED', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900))),
        const SizedBox(height: 7), Text(t.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4), Text(t.synopsis ?? 'Stream now on PlayTv.', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: PlayTvColors.muted, fontSize: 11)),
        const SizedBox(height: 10), Row(children: [ElevatedButton.icon(onPressed: () => onTap(t), icon: const Icon(Icons.play_arrow_rounded, size: 18), label: const Text('WATCH NOW')), const SizedBox(width: 8), OutlinedButton.icon(onPressed: () => onTap(t), icon: const Icon(Icons.info_outline_rounded, size: 17), label: const Text('DETAILS'))]),
      ])),
    ]));
  }
}

class _Continue extends StatelessWidget {
  final List<Progress> items; final void Function(Progress) onTap;
  const _Continue({required this.items, required this.onTap});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Padding(padding: EdgeInsets.fromLTRB(16, 18, 16, 10), child: Text('Continue Watching', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
    SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (_, i) { final p = items[i]; final t = p.title!; return InkWell(onTap: () => onTap(p), borderRadius: BorderRadius.circular(9), child: SizedBox(width: 286, child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(width: 66, height: 94, child: t.poster == null ? Container(color: PlayTvColors.surface2) : Image.network(t.poster!, fit: BoxFit.cover))), const SizedBox(width: 9), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)), const SizedBox(height: 9), LinearProgressIndicator(value: p.percent, minHeight: 4, backgroundColor: PlayTvColors.line, color: PlayTvColors.green), const SizedBox(height: 5), Text('${(p.percent * 100).round()}% watched', style: const TextStyle(color: PlayTvColors.muted, fontSize: 9))])), const SizedBox(width: 2), MoreIconButton(onPressed: () {})])); }))
  ]);
}

class _ErrorView extends StatelessWidget { final String error; final VoidCallback onRetry; const _ErrorView(this.error, {required this.onRetry}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 42, color: PlayTvColors.muted), const SizedBox(height: 10), Text(error, textAlign: TextAlign.center, style: const TextStyle(color: PlayTvColors.muted)), const SizedBox(height: 12), ElevatedButton(onPressed: onRetry, child: const Text('RETRY'))]))); }
