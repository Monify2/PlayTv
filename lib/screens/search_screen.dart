import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final api = ApiService();
  List<PlayTitle> results = [];
  bool loading = false;
  String? error;

  Future<void> runSearch() async {
    final q = controller.text.trim();
    if (q.isEmpty) return;
    setState(() { loading = true; error = null; });
    try {
      final data = await api.search(q);
      if (mounted) setState(() { results = data; loading = false; });
    } catch (e) {
      if (mounted) setState(() { error = '$e'; loading = false; });
    }
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => runSearch(),
            decoration: const InputDecoration(
              hintText: 'Search movies, series and people',
              border: InputBorder.none,
              filled: false,
            ),
          ),
          actions: [
            IconButton(
              onPressed: runSearch,
              icon: const Icon(Icons.search_rounded),
            ),
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator(color: PlayTvColors.green))
            : error != null
                ? Center(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(error!, textAlign: TextAlign.center),
                  ))
                : results.isEmpty
                    ? const Center(
                        child: Text('Search the PlayTv catalogue',
                            style: TextStyle(color: PlayTvColors.muted)),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(14),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 160,
                          mainAxisExtent: 250,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: results.length,
                        itemBuilder: (_, i) => MovieCard(
                          item: results[i],
                          width: 160,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                id: results[i].id,
                                fallback: results[i],
                              ),
                            ),
                          ),
                        ),
                      ),
      );
}
