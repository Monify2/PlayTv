import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/icon_style.dart';
import 'home_screen.dart';
import 'browse_screen.dart';
import 'downloads_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  void goSearch() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
  void goMenu() => setState(() => index = 4);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenSearch: goSearch, onOpenMenu: goMenu),
      BrowseScreen(initialType: 'movie'),
      const BrowseScreen(initialType: 'series'),
      const DownloadsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        backgroundColor: Colors.black,
        indicatorColor: PlayTvColors.green.withValues(alpha: .16),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: PlayTvIcon(Icons.home_outlined),
            selectedIcon: PlayTvIcon(Icons.home, active: true),
            label: 'Home',
          ),
          NavigationDestination(
            icon: PlayTvIcon(Icons.movie_outlined),
            selectedIcon: PlayTvIcon(Icons.movie, active: true),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: PlayTvIcon(Icons.tv_outlined),
            selectedIcon: PlayTvIcon(Icons.tv, active: true),
            label: 'TV Series',
          ),
          NavigationDestination(
            icon: PlayTvIcon(Icons.cloud_download_outlined),
            selectedIcon: PlayTvIcon(Icons.cloud_download, active: true),
            label: 'Downloads',
          ),
          NavigationDestination(
            icon: PlayTvIcon(Icons.menu_rounded),
            selectedIcon: PlayTvIcon(Icons.menu_rounded, active: true),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
