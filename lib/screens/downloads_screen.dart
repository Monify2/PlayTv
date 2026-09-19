import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/title.dart';
import '../services/api_service.dart';
import '../widgets/icon_style.dart';
import 'detail_screen.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});
  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final api = ApiService();
  List<PlayTitle> items = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final x = await api.downloads();
      if (mounted)
        setState(() {
          items = x;
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 10, 10),
          child: Row(
            children: [
              const Text(
                'Downloads',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              IconButton(
                onPressed: load,
                tooltip: 'Refresh',
                icon: const PlayTvIcon(Icons.refresh_rounded),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlayTvIcon(Icons.cloud_download_outlined, size: 42),
                      SizedBox(height: 10),
                      Text(
                        'No downloads yet',
                        style: TextStyle(color: PlayTvColors.muted),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final t = items[i];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: PlayTvColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: SizedBox(
                          width: 55,
                          height: 70,
                          child: t.poster == null
                              ? const Center(
                                  child: PlayTvIcon(Icons.movie_outlined),
                                )
                              : Image.network(t.poster!, fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(
                        t.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        'Available offline',
                        style: TextStyle(
                          color: PlayTvColors.green,
                          fontSize: 11,
                        ),
                      ),
                      trailing: const PlayTvIcon(Icons.more_horiz_rounded),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(id: t.id, fallback: t),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
