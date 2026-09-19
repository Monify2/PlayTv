import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    if (AppConfig.supabasePublishableKey.isEmpty) return;
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabasePublishableKey,
    );
  }

  static bool get isReady => AppConfig.supabasePublishableKey.isNotEmpty;
}
