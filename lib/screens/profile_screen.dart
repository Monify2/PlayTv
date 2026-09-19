import 'package:flutter/material.dart';

import 'plans_screen.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/brand.dart';
import '../widgets/icon_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? me;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final x = await ApiService().me();
      if (mounted) setState(() => me = x);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final email =
        me?['email']?.toString() ?? AuthService().user?.email ?? 'Guest';
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          Row(
            children: [
              const PlayTvBrand(compact: true),
              const Spacer(),
              const MoreIconButton(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: PlayTvColors.green,
                child: Text(
                  email.isEmpty ? 'P' : email[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: PlayTvColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _Setting(icon: Icons.person_outline_rounded, title: 'Account'),
          _Setting(
            icon: Icons.workspace_premium_outlined,
            title: 'Subscription',
            trailing: 'FREE',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlansScreen()),
            ),
          ),
          const _Setting(
            icon: Icons.high_quality_outlined,
            title: 'Playback quality',
            trailing: 'AUTO',
          ),
          const _Setting(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
          ),
          const _Setting(
            icon: Icons.cloud_download_outlined,
            title: 'Downloads',
          ),
          const _Setting(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            trailing: 'DARK',
          ),
          const _Setting(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: const PlayTvIcon(
                Icons.logout_rounded,
                color: PlayTvColors.danger,
              ),
              label: const Text(
                'SIGN OUT',
                style: TextStyle(
                  color: PlayTvColors.danger,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Setting extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  const _Setting({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: PlayTvColors.surface,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: PlayTvColors.line),
    ),
    child: ListTile(
      dense: true,
      leading: PlayTvIcon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: trailing != null
          ? Text(
              trailing!,
              style: const TextStyle(
                color: PlayTvColors.green,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            )
          : const PlayTvIcon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    ),
  );
}
