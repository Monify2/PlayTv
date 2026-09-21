import 'package:dio/dio.dart';

import '../core/config.dart';
import 'supabase_service.dart';

class AdPlacement {
  final String name;
  final String position;
  final int secondsAfterStart;
  final bool rewardDownload;
  final String? adUrl;

  const AdPlacement({
    required this.name,
    required this.position,
    required this.secondsAfterStart,
    required this.rewardDownload,
    this.adUrl,
  });

  factory AdPlacement.fromJson(Map<String, dynamic> json) => AdPlacement(
        name: '${json['name'] ?? 'Ad'}',
        position: '${json['position'] ?? 'mid'}',
        secondsAfterStart: int.tryParse('${json['seconds_after_start'] ?? 0}') ?? 0,
        rewardDownload: json['reward_download'] == true,
        adUrl: json['ad_url']?.toString(),
      );
}

class AdService {
  final Dio _dio = Dio();

  Future<List<AdPlacement>> placements() async {
    if (!SupabaseService.isReady) return const [];
    final session = SupabaseService.client.auth.currentSession;
    if (session == null) throw Exception('Please sign in again.');

    final response = await _dio.get(
      '${AppConfig.supabaseUrl}/functions/v1/playtv-ads',
      options: Options(headers: {
        'Authorization': 'Bearer ${session.accessToken}',
        'apikey': AppConfig.supabasePublishableKey,
      }),
    );

    final data = response.data;
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception(data is Map ? '${data['error'] ?? 'Ads unavailable'}' : 'Ads unavailable');
    }

    final list = data is Map ? data['placements'] : null;
    return (list is List)
        ? list.whereType<Map>().map((e) => AdPlacement.fromJson(Map<String, dynamic>.from(e))).toList()
        : const [];
  }
}
