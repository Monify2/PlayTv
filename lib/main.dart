import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme.dart';
import 'services/supabase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const PlayTvApp());
}

class PlayTvApp extends StatelessWidget {
  const PlayTvApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(title: 'PlayTv', debugShowCheckedModeBanner: false, theme: PlayTvTheme.dark(), home: SupabaseService.isReady ? const AuthGate() : const AuthScreen());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override Widget build(BuildContext context) => StreamBuilder<AuthState>(stream: SupabaseService.client.auth.onAuthStateChange, builder: (_, __) => SupabaseService.client.auth.currentSession == null ? const AuthScreen() : const AppShell());
}
