import '../video_provider.dart';

/// Documents the provider boundary used by the client.
///
/// The concrete FastPixAdapter/MuxAdapter live on the Supabase Edge Function
/// side. Keeping this registry in the app makes provider identity explicit
/// without allowing the UI to depend on either vendor SDK/API.
class ProviderRegistry {
  static VideoProvider parse(String? provider) => videoProviderFromString(provider);

  static const supported = <VideoProvider>[
    VideoProvider.fastpix,
    VideoProvider.mux,
    VideoProvider.custom,
  ];
}
