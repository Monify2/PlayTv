class PlayTitle {
  final String id;
  final String name;
  final String type;
  final String? synopsis;
  final String? poster;
  final String? backdrop;
  final String? trailer;
  final String? releaseDate;
  final int? runtime;
  final String? rating;
  final double score;
  final bool premium;
  final bool featured;
  final List<String> tags;
  final Map<String, dynamic> raw;

  const PlayTitle({
    required this.id,
    required this.name,
    required this.type,
    this.synopsis,
    this.poster,
    this.backdrop,
    this.trailer,
    this.releaseDate,
    this.runtime,
    this.rating,
    this.score = 0,
    this.premium = false,
    this.featured = false,
    this.tags = const [],
    this.raw = const {},
  });

  factory PlayTitle.fromJson(Map<String, dynamic> json) {
    return PlayTitle(
      id: '${json['id'] ?? ''}',
      name: '${json['title'] ?? json['name'] ?? 'Untitled'}',
      type: '${json['type'] ?? 'movie'}',
      synopsis: json['synopsis']?.toString(),
      poster: _url(json['poster_url'] ?? json['poster']),
      backdrop: _url(json['backdrop_url'] ?? json['backdrop']),
      trailer: _url(json['trailer_url'] ?? json['trailer']),
      releaseDate: json['release_date']?.toString(),
      runtime: _int(json['runtime']),
      rating: json['maturity_rating']?.toString() ?? json['rating']?.toString(),
      score: _double(
        json['recommendation_score'] ??
            json['popularity_score'] ??
            json['vote_average'],
      ),
      premium: json['is_premium'] == true || json['premium'] == true,
      featured: json['is_featured'] == true || json['featured'] == true,
      tags: (json['tags'] is List)
          ? List<String>.from((json['tags'] as List).map((e) => '$e'))
          : const [],
      raw: json,
    );
  }

  static String? _url(dynamic value) =>
      value == null || '$value'.isEmpty ? null : '$value';
  static int? _int(dynamic value) =>
      value == null ? null : int.tryParse('$value');
  static double _double(dynamic value) => double.tryParse('$value') ?? 0;
}

class Progress {
  final String id;
  final String? titleId;
  final String? episodeId;
  final double position;
  final double duration;
  final bool completed;
  final PlayTitle? title;

  const Progress({
    this.id = '',
    this.titleId,
    this.episodeId,
    this.position = 0,
    this.duration = 0,
    this.completed = false,
    this.title,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    id: '${json['id'] ?? ''}',
    titleId: json['title_id']?.toString(),
    episodeId: json['episode_id']?.toString(),
    position:
        double.tryParse(
          '${json['position_seconds'] ?? json['position'] ?? 0}',
        ) ??
        0,
    duration:
        double.tryParse(
          '${json['duration_seconds'] ?? json['duration'] ?? 0}',
        ) ??
        0,
    completed: json['completed'] == true,
    title: json['title'] is Map
        ? PlayTitle.fromJson(Map<String, dynamic>.from(json['title']))
        : null,
  );

  double get percent => duration <= 0 ? 0 : (position / duration).clamp(0, 1);
}
