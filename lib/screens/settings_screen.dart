import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/icon_style.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final api = ApiService();
  String quality = 'AUTO';
  String downloadQuality = 'HD';
  String audio = 'Default';
  String subtitles = 'Default';
  List<dynamic> plans = [];
  List<dynamic> prices = [];
  bool loadingPlans = true;

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    try {
      final p = await api.plans();
      final c = await api.prices('NGN');
      if (mounted) setState(() { plans = p; prices = c; loadingPlans = false; });
    } catch (_) {
      if (mounted) setState(() => loadingPlans = false);
    }
  }

  void choose(String title, List<String> options, String current, ValueChanged<String> save) {
    showModalBottomSheet(
      context: context,
      backgroundColor: PlayTvColors.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            for (final option in options)
              ListTile(
                title: Text(option),
                trailing: option == current ? const PlayTvIcon(Icons.check_rounded, active: true) : null,
                onTap: () { save(option); Navigator.pop(context); },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        const _Header('Playback'),
        _Row('Playback quality', quality, Icons.high_quality_outlined, () =>
          choose('Playback quality', ['AUTO', 'SD', 'HD', 'FULL HD', '4K'], quality, (v) => setState(() => quality = v))),
        _Row('Audio language', audio, Icons.volume_up_outlined, () =>
          choose('Audio language', ['Default', 'English'], audio, (v) => setState(() => audio = v))),
        _Row('Subtitles', subtitles, Icons.subtitles_outlined, () =>
          choose('Subtitles', ['Default', 'Off', 'English'], subtitles, (v) => setState(() => subtitles = v))),
        const _Header('Downloads'),
        _Row('Download quality', downloadQuality, Icons.download_outlined, () =>
          choose('Download quality', ['SD', 'HD', 'FULL HD'], downloadQuality, (v) => setState(() => downloadQuality = v))),
        const _Header('Subscription'),
        if (loadingPlans)
          const Padding(padding: EdgeInsets.all(18), child: Center(child: CircularProgressIndicator(color: PlayTvColors.green)))
        else if (plans.isEmpty)
          const _EmptyCard('Plans will appear here when configured.')
        else
          for (final plan in plans)
            _PlanCard(plan: plan, prices: prices),
        const _Header('Account'),
        _Row('Help & Support', 'Contact support', Icons.help_outline_rounded, () {}),
        _Row('About PlayTv', 'Version 1.0', Icons.info_outline_rounded, () =>
          showAboutDialog(context: context, applicationName: 'PlayTv', applicationVersion: '1.0.0')),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => AuthService().signOut(),
          icon: const PlayTvIcon(Icons.logout_rounded, color: PlayTvColors.danger),
          label: const Text('SIGN OUT', style: TextStyle(color: PlayTvColors.danger, fontWeight: FontWeight.w800)),
        ),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 20, 2, 8),
    child: Text(text.toUpperCase(), style: const TextStyle(color: PlayTvColors.muted, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
  );
}

class _Row extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final VoidCallback onTap;
  const _Row(this.title, this.value, this.icon, this.onTap);
  @override Widget build(BuildContext context) => Card(
    color: PlayTvColors.surface,
    child: ListTile(
      leading: PlayTvIcon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(value, style: const TextStyle(color: PlayTvColors.muted, fontSize: 11)),
      trailing: const PlayTvIcon(Icons.chevron_right_rounded),
      onTap: onTap,
    ),
  );
}

class _EmptyCard extends StatelessWidget {
  final String text;
  const _EmptyCard(this.text);
  @override Widget build(BuildContext context) => Card(color: PlayTvColors.surface, child: Padding(padding: const EdgeInsets.all(16), child: Text(text, style: const TextStyle(color: PlayTvColors.muted))));
}

class _PlanCard extends StatelessWidget {
  final dynamic plan;
  final List<dynamic> prices;
  const _PlanCard({required this.plan, required this.prices});
  @override Widget build(BuildContext context) {
    final m = plan is Map ? Map<String,dynamic>.from(plan) : <String,dynamic>{};
    final id = '${m['id'] ?? ''}';
    dynamic price;
    for (final p in prices) {
      if (p is Map && '${p['plan_id'] ?? ''}' == id) { price = p; break; }
    }
    return Card(
      color: PlayTvColors.surface,
      child: ListTile(
        title: Text('${m['name'] ?? m['code'] ?? 'Plan'}', style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('${m['description'] ?? 'Premium PlayTv access'}'),
        trailing: Text('${price is Map ? (price['amount'] ?? '') : ''} ${price is Map ? (price['currency'] ?? '') : ''}',
          style: const TextStyle(color: PlayTvColors.green, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
