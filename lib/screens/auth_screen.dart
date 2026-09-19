import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import 'shell.dart';
import '../widgets/brand.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const Center(child: PlayTvBrand()),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Better stories. Anytime.',
                      style: TextStyle(color: PlayTvColors.muted),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    signUp ? 'Create account' : 'Welcome back',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    signUp
                        ? 'Join PlayTv and keep your entertainment in one place.'
                        : 'Sign in to continue watching.',
                    style: const TextStyle(color: PlayTvColors.muted),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email or username',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        error!,
                        style: const TextStyle(
                          color: PlayTvColors.danger,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: busy ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PlayTvColors.green,
                        foregroundColor: Colors.black,
                      ),
                      child: busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              signUp ? 'SIGN UP' : 'SIGN IN',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      signUp = !signUp;
                      error = null;
                    }),
                    child: Text(
                      signUp
                          ? 'Already have an account? Sign in'
                          : 'Don\'t have an account? Sign up',
                    ),
                  ),
                  if (!SupabaseService.isReady) ...[
                    const SizedBox(height: 16),
                    const Divider(color: PlayTvColors.line),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const AppShell()),
                      ),
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('PREVIEW PLAYTV'),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Preview mode is enabled until a Supabase publishable key is supplied.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PlayTvColors.muted, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool signUp = false;
  bool busy = false;
  String? error;

  Future<void> submit() async {
    if (!SupabaseService.isReady) {
      setState(
        () => error = 'Add SUPABASE_PUBLISHABLE_KEY when building the app.',
      );
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (signUp) {
        await AuthService().signUp(email.text, password.text);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Account created. Check your email if confirmation is enabled.',
              ),
            ),
          );
      } else {
        await AuthService().signIn(email.text, password.text);
      }
    } catch (e) {
      if (mounted)
        setState(() => error = e.toString().replaceFirst('Exception: ', ''));
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                const Center(child: PlayTvBrand()),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Better stories. Anytime.',
                    style: TextStyle(color: PlayTvColors.muted),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  signUp ? 'Create account' : 'Welcome back',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  signUp
                      ? 'Join PlayTv and keep your entertainment in one place.'
                      : 'Sign in to continue watching.',
                  style: const TextStyle(color: PlayTvColors.muted),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email or username',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      error!,
                      style: const TextStyle(
                        color: PlayTvColors.danger,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: busy ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PlayTvColors.green,
                      foregroundColor: Colors.black,
                    ),
                    child: busy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            signUp ? 'SIGN UP' : 'SIGN IN',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {
                    signUp = !signUp;
                    error = null;
                  }),
                  child: Text(
                    signUp
                        ? 'Already have an account? Sign in'
                        : 'Don\'t have an account? Sign up',
                  ),
                ),
                if (!SupabaseService.isReady) ...[
                  const SizedBox(height: 16),
                  const Divider(color: PlayTvColors.line),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AppShell()),
                    ),
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('PREVIEW PLAYTV'),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Preview mode is enabled until a Supabase publishable key is supplied.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: PlayTvColors.muted, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
