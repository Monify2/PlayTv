import 'package:dio/dio.dart';
import '../core/config.dart';
import '../models/title.dart';
import 'supabase_service.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<dynamic> call(String route, {String method = 'GET', Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
    if (!SupabaseService.isReady) return {'items': <dynamic>[]};
    final session = SupabaseService.client.auth.currentSession;
    if (session == null) throw Exception('Please sign in again.');
    final response = await _dio.request(
      '${AppConfig.supabaseUrl}/functions/v1/${AppConfig.apiFunction}/$route',
      data: method == 'GET' ? null : body,
      queryParameters: query,
      options: Options(
        method: method,
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
          'apikey': AppConfig.supabasePublishableKey,
          'Content-Type': 'application/json',
        },
        validateStatus: (s) => s != null && s < 500,
      ),
    );
    final data = response.data;
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception(data is Map ? '${data['error'] ?? 'Request failed'}' : 'Request failed');
    }
    return data;
  }

  Future<Map<String, dynamic>> home() async => Map<String, dynamic>.from(await call('home'));

  Future<List<PlayTitle>> titles({String? type, String? q, String? sort}) async {
    final data = await call('titles', query: {
      if (type != null) 'type': type,
      if (q != null && q.isNotEmpty) 'q': q,
      if (sort != null) 'sort': sort,
    });
    return _titles(data);
  }

  Future<List<PlayTitle>> search(String q, {String? type}) async {
    final data = await call('search', query: {'q': q, if (type != null) 'type': type});
    return _titles(data);
  }

  Future<Map<String, dynamic>> title(String id) async => Map<String, dynamic>.from(await call('titles/$id'));

  Future<List<PlayTitle>> watchlist() async {
    final data = await call('watchlist');
    final items = (data['items'] as List?) ?? const [];
    return items.where((e) => e is Map && e['title'] != null).map((e) => PlayTitle.fromJson(Map<String, dynamic>.from(e['title']))).toList();
  }

  Future<void> addWatchlist(String id) => call('watchlist', method: 'POST', body: {'title_id': id});
  Future<void> removeWatchlist(String id) => call('watchlist/$id', method: 'DELETE');

  Future<List<Progress>> progress() async {
    final data = await call('progress');
    return ((data['items'] as List?) ?? const []).whereType<Map>().map((e) => Progress.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> saveProgress({String? titleId, String? episodeId, required double position, double? duration, bool completed = false}) => call(
        'progress',
        method: 'POST',
        body: {
          if (titleId != null) 'title_id': titleId,
          if (episodeId != null) 'episode_id': episodeId,
          'position_seconds': position,
          if (duration != null) 'duration_seconds': duration,
          'completed': completed,
        },
      );

  Future<List<PlayTitle>> downloads() async {
    final data = await call('downloads');
    return ((data['items'] as List?) ?? const []).where((e) => e is Map && e['title'] != null).map((e) => PlayTitle.fromJson(Map<String, dynamic>.from(e['title']))).toList();
  }

  Future<List<dynamic>> plans() async => (await call('plans'))['items'] ?? const [];
  Future<List<dynamic>> prices(String currency) async => (await call('plans/prices', query: {'currency': currency}))['items'] ?? const [];
  Future<Map<String, dynamic>> me() async => Map<String, dynamic>.from(await call('me'));

  List<PlayTitle> _titles(dynamic data) => ((data is Map ? data['items'] : null) as List? ?? const []).whereType<Map>().map((e) => PlayTitle.fromJson(Map<String, dynamic>.from(e))).toList();
}
