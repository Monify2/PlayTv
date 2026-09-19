import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import '../services/api_service.dart';
import '../services/demo_catalog.dart';
import '../services/supabase_service.dart';
import '../widgets/movie_card.dart';
import '../widgets/top_bar.dart';
import 'detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  final String? initialType;
  const BrowseScreen({super.key, this.initialType});
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final api = ApiService();
  final search = TextEditingController();
  List<PlayTitle> items = [];
  bool loading = true;
  String? type;
  String sort = 'popular';
  @override
  void initState() {
    super.initState();
    type = widget.initialType;
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    if (!SupabaseService.isReady) {
      var data = DemoCatalog.titles;
      if (type != null) data = data.where((t) => t.type == type).toList();
      if (search.text.trim().isNotEmpty) {
        final q = search.text.trim().toLowerCase();
        data = data
            .where(
              (t) =>
                  t.name.toLowerCase().contains(q) ||
                  (t.synopsis ?? '').toLowerCase().contains(q),
            )
            .toList();
      }
      if (mounted)
        setState(() {
          items = data;
          loading = false;
        });
      return;
    }
    try {
      final data = await api.titles(type: type, q: search.text, sort: sort);
      if (mounted)
        setState(() {
          items = data;
          loading = false;
        });
    } catch (_) {
      var data = DemoCatalog.titles;
      if (type != null) data = data.where((t) => t.type == type).toList();
      if (search.text.trim().isNotEmpty) {
        final q = search.text.trim().toLowerCase();
        data = data
            .where(
              (t) =>
                  t.name.toLowerCase().contains(q) ||
                  (t.synopsis ?? '').toLowerCase().contains(q),
            )
            .toList();
      }
      if (mounted)
        setState(() {
          items = data;
          loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        TopBar(
          onSearch: () => FocusScope.of(context).requestFocus(FocusNode()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
          child: TextField(
            controller: search,
            onSubmitted: (_) => load(),
            decoration: InputDecoration(
              hintText: 'Search movies, series...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  search.clear();
                  load();
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Row(
            children: [
              for (final x in [
                ('All', null),
                ('Movies', 'movie'),
                ('Series', 'series'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(x.$1),
                    selected: type == x.$2,
                    onSelected: (_) {
                      setState(() => type = x.$2);
                      load();
                    },
                  ),
                ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Row(
            children: [
              for (final x in ['popular', 'newest', 'rating'])
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(x.toUpperCase()),
                    selected: sort == x,
                    onSelected: (_) {
                      setState(() => sort = x);
                      load();
                    },
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: PlayTvColors.green),
                )
              : items.isEmpty
              ? const Center(
                  child: Text(
                    'No titles found',
                    style: TextStyle(color: PlayTvColors.muted),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisExtent: 244,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => MovieCard(
                    item: items[i],
                    width: 150,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailScreen(id: items[i].id, fallback: items[i]),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
