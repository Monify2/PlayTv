import 'package:dio/dio.dart';

import '../core/config.dart';
import 'supabase_service.dart';

class PlaybackResult {
  final String url;
  final String? title;
  const PlaybackResult(this.url, {this.title});
}

class PlaybackService {
  final Dio _dio = Dio();

  Future<PlaybackResult> getPlayback({
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
        },
      ),
    );
    final data = Map<String, dynamic>.from(
      response.data is Map ? response.data : {},
    );
    if (response.statusCode == null ||
        response.statusCode! >= 400 ||
        data['url'] == null) {
      throw Exception('${data['error'] ?? 'Playback is not available'}');
    }
    return PlaybackResult('${data['url']}', title: data['title']?.toString());
  }
}
