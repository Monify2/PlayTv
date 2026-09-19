import 'package:dio/dio.dart';
import '../core/config.dart';
import 'supabase_service.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> create({required String titleId, String? episodeId, String quality = 'HD'}) async {
    if (!SupabaseService.isReady) throw Exception('PlayTv backend is not configured.');
    final session = SupabaseService.client.auth.currentSession;
    if (session == null) throw Exception('Please sign in again.');
    final response = await _dio.post(
      '${AppConfig.supabaseUrl}/functions/v1/${AppConfig.downloadFunction}',
      data: {'title_id': titleId, if (episodeId != null) 'episode_id': episodeId, 'quality': quality},
      options: Options(headers: {
        'Authorization': 'Bearer ${session.accessToken}',
        'apikey': AppConfig.supabasePublishableKey,
        'Content-Type': 'application/json',
      }),
    );
    if ((response.statusCode ?? 500) >= 400) {
      final body = response.data is Map ? Map<String, dynamic>.from(response.data) : const <String, dynamic>{};
      throw Exception('${body['error'] ?? 'Download could not be started'}');
    }
    return response.data is Map ? Map<String, dynamic>.from(response.data) : <String, dynamic>{};
  }
}
