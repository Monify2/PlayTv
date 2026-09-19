import 'package:dio/dio.dart';

import '../core/config.dart';
import 'supabase_service.dart';
import 'video_provider.dart';

/// Provider-neutral playback gateway.
///
/// FastPix, Mux and future providers are selected on the server from the
/// video_sources.provider value. Flutter never needs provider credentials or
/// provider-specific URL construction.
class PlaybackService implements VideoPlaybackProvider {
  final Dio _dio;

  PlaybackService({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<PlaybackDescriptor> getPlayback({
    required String titleId,
    String? episodeId,
  }) async {
    final session = SupabaseService.client.auth.currentSession;
    if (session == null) throw Exception('Please sign in again.');

    final response = await _dio.post(
      '${AppConfig.supabaseUrl}/functions/v1/${AppConfig.playbackFunction}',
      data: {
        'title_id': titleId,
        if (episodeId != null) 'episode_id': episodeId,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
          'apikey': AppConfig.supabasePublishableKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    final data = Map<String, dynamic>.from(
      response.data is Map ? response.data : const <String, dynamic>{},
    );
    if ((response.statusCode ?? 500) >= 400 || data['url'] == null) {
      throw Exception('${data['error'] ?? 'Playback is not available'}');
    }

    return PlaybackDescriptor.fromJson(data);
  }
}
