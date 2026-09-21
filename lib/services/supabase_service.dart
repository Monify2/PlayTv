import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config.dart';

class SupabaseService {
  static String? initializationError;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    if (AppConfig.supabasePublishableKey.isEmpty) {
      initializationError =
          'PlayTv backend is not configured. Add SUPABASE_PUBLISHABLE_KEY to the release build.';
      return;
    }
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.supabasePublishableKey,
      );
      initializationError = null;
    } catch (e) {
      initializationError = 'Supabase initialization failed: $e';
    }
  }

  static bool get isReady =>
      AppConfig.supabasePublishableKey.isNotEmpty &&
      initializationError == null;
}
