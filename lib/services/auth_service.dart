import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  Future<void> signIn(String email, String password) async {
    await SupabaseService.client.auth.signInWithPassword(email: email.trim(), password: password);
  }

  Future<void> signUp(String email, String password) async {
    await SupabaseService.client.auth.signUp(email: email.trim(), password: password);
  }

  Future<void> signOut() => SupabaseService.client.auth.signOut();

  User? get user => SupabaseService.client.auth.currentUser;
}
