class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tjafuugwrmntmsxoivox.supabase.co',
  );
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_xtP3DFOxlJxj90iF5nQdaw_jD2M9Pem',
  );
  static const apiFunction = 'playtv-api';
  static const playbackFunction = 'playtv-playback';
  static const downloadFunction = 'playtv-download';
}
