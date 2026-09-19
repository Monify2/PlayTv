/// Provider-neutral playback models used by the Flutter client.
///
/// The app never constructs FastPix or Mux URLs itself. The protected
/// playtv-playback Edge Function resolves the provider and returns a common
/// descriptor to the client.
enum VideoProvider { fastpix, mux, custom }

VideoProvider videoProviderFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'fastpix':
      return VideoProvider.fastpix;
    case 'mux':
      return VideoProvider.mux;
    default:
      return VideoProvider.custom;
  }
}

class PlaybackTrack {
  final String? id;
  final String? language;
  final String? label;
  final String? kind;
  final String? url;

  const PlaybackTrack({
    this.id,
    this.language,
    this.label,
    this.kind,
    this.url,
  });

  factory PlaybackTrack.fromJson(Map<String, dynamic> json) => PlaybackTrack(
    id: json['id']?.toString(),
    language: json['language']?.toString(),
    label: json['label']?.toString(),
    kind: json['kind']?.toString(),
    url: json['url']?.toString(),
  );
}

class PlaybackDescriptor {
  final String url;
  final VideoProvider provider;
  final String? providerAssetId;
  final String? playbackId;
  final String? title;
  final DateTime? expiresAt;
  final List<PlaybackTrack> subtitles;
  final List<PlaybackTrack> audioTracks;

  const PlaybackDescriptor({
    required this.url,
    required this.provider,
    this.providerAssetId,
    this.playbackId,
    this.title,
    this.expiresAt,
    this.subtitles = const [],
    this.audioTracks = const [],
  });

  factory PlaybackDescriptor.fromJson(Map<String, dynamic> json) {
    final subtitleJson = json['subtitles'] is List
        ? List<Map<String, dynamic>>.from(
            (json['subtitles'] as List).whereType<Map>().map(
              Map<String, dynamic>.from,
            ),
          )
        : const <Map<String, dynamic>>[];
    final audioJson = json['audio_tracks'] is List
        ? List<Map<String, dynamic>>.from(
            (json['audio_tracks'] as List).whereType<Map>().map(
              Map<String, dynamic>.from,
            ),
          )
        : const <Map<String, dynamic>>[];

    DateTime? expiresAt;
    final rawExpiry = json['expires_at']?.toString();
    if (rawExpiry != null) expiresAt = DateTime.tryParse(rawExpiry);

    return PlaybackDescriptor(
      url: json['url']?.toString() ?? '',
      provider: videoProviderFromString(json['provider']?.toString()),
      providerAssetId: json['provider_asset_id']?.toString(),
      playbackId: json['playback_id']?.toString(),
      title: json['title']?.toString(),
      expiresAt: expiresAt,
      subtitles: subtitleJson
          .map(PlaybackTrack.fromJson)
          .toList(growable: false),
      audioTracks: audioJson
          .map(PlaybackTrack.fromJson)
          .toList(growable: false),
    );
  }
}

/// Client-side provider boundary. Implementations should call the single
/// provider-neutral PlayTv playback API rather than provider APIs directly.
abstract interface class VideoPlaybackProvider {
  Future<PlaybackDescriptor> getPlayback({
    required String titleId,
    String? episodeId,
  });
}
