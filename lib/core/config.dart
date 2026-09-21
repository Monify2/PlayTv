class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tjafuugwrmntmsxoivox.supabase.co',
  );
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: '',
  );
  static const apiFunction = 'playtv-api';
  static const playbackFunction = 'playtv-playback';
  static const downloadFunction = 'playtv-download';
}
