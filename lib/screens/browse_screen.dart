import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import '../widgets/top_bar.dart';
import 'detail_screen.dart';
import 'search_screen.dart';

class BrowseScreen extends StatefulWidget {
  final String? initialType;
  const BrowseScreen({super.key, this.initialType});
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final api = ApiService();
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
    try {
      final data = await api.titles(type: type, sort: sort);
      if (mounted)
        setState(() {
          items = data;
          loading = false;
        });
    } catch (_) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        TopBar(
          onSearch: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
        ),
        const SizedBox(height: 8),
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
