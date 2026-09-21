import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../core/config.dart';
import 'supabase_service.dart';

class OfflineDownloadResult {
  final File videoFile;
  final File? subtitleFile;

  const OfflineDownloadResult(this.videoFile, {this.subtitleFile});
}

class DownloadService {
  final Dio _dio = Dio();

  Future<OfflineDownloadResult> downloadOffline({
    required String titleId,
    String? episodeId,
    required String fileName,
    required bool rewardAdCompleted,
    required String quality,
    required void Function(double progress) onProgress,
  }) async {
    if (!SupabaseService.isReady) {
      throw Exception('PlayTv backend is not configured.');
    }
    final session = SupabaseService.client.auth.currentSession;
    if (session == null) throw Exception('Please sign in again.');

    final response = await _dio.post(
      '${AppConfig.supabaseUrl}/functions/v1/${AppConfig.downloadFunction}',
      data: {
        'title_id': titleId,
        if (episodeId != null) 'episode_id': episodeId,
        'quality': quality,
        'reward_ad_completed': rewardAdCompleted,
      },
      options: Options(headers: {
        'Authorization': 'Bearer ${session.accessToken}',
        'apikey': AppConfig.supabasePublishableKey,
      }),
    );

    final data = response.data is Map
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};

    if (response.statusCode == null || response.statusCode! >= 400 || data['download_url'] == null) {
      throw Exception('${data['error'] ?? 'Download is not available'}');
    }

    final directory = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${directory.path}/playtv/offline');
    if (!await mediaDir.exists()) await mediaDir.create(recursive: true);

    final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');
    final videoPath = '${mediaDir.path}/$safeName.mp4';
    await _dio.download(
      '${data['download_url']}',
      videoPath,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress(received / total);
      },
      options: Options(headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      }),
    );

    File? subtitle;
    final subtitleUrl = data['subtitle_url']?.toString();
    if (subtitleUrl != null && subtitleUrl.isNotEmpty) {
      final subtitlePath = '${mediaDir.path}/$safeName.vtt';
      await _dio.download(subtitleUrl, subtitlePath);
      subtitle = File(subtitlePath);
    }

    return OfflineDownloadResult(File(videoPath), subtitleFile: subtitle);
  }

  Future<String?> getOfflineMoviePath(String movieId) async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/playtv/offline');
    if (!await dir.exists()) return null;
    final files = dir.listSync().whereType<File>();
    for (final file in files) {
      if (file.path.split('/').last.startsWith(movieId)) return file.path;
    }
    return null;
  }
}
