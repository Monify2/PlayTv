import '../models/title.dart';

/// Offline preview catalogue used when the app is built without a Supabase
/// publishable key. It keeps the complete UI explorable while development is
/// still happening. Production builds use the real API automatically.
class DemoCatalog {
  static const _base = 'https://picsum.photos/seed';

  static List<PlayTitle> get titles => [
        _title('demo-1', 'Midnight Protocol', 'movie', 'A former intelligence analyst is pulled back into a quiet war that has no official record.', 'midnight', 8.7, true),
        _title('demo-2', 'The Last Signal', 'movie', 'A stranded crew receives a transmission that should have arrived decades ago.', 'signal', 8.4, false),
        _title('demo-3', 'Neon District', 'series', 'A detective and a street engineer uncover a conspiracy beneath a city built on artificial light.', 'neon', 9.0, true),
        _title('demo-4', 'Northbound', 'movie', 'Three strangers share one overnight journey across a frozen continent.', 'northbound', 8.1, false),
        _title('demo-5', 'After the Fall', 'series', 'Survivors rebuild a fractured world while discovering why the collapse happened.', 'fall', 8.8, false),
        _title('demo-6', 'Black Tide', 'movie', 'A salvage crew finds something impossible beneath an abandoned offshore platform.', 'tide', 7.9, false),
        _title('demo-7', 'Zero Hour', 'movie', 'A race against the clock begins when every digital clock in a city stops at once.', 'zero', 8.5, true),
        _title('demo-8', 'Glass Kingdom', 'series', 'Power, family and secrets collide inside a dynasty that controls an entire media empire.', 'glass', 8.6, false),
      ];

  static PlayTitle _title(String id, String name, String type, String synopsis, String seed, double score, bool premium) {
    return PlayTitle(
      id: id,
      name: name,
      type: type,
      synopsis: synopsis,
      poster: '$_base/$seed/600/900',
      backdrop: '$_base/${seed}wide/1200/700',
      releaseDate: '2026-02-14',
      runtime: type == 'movie' ? 118 : null,
      rating: '16+',
      score: score,
      premium: premium,
      featured: id == 'demo-1',
      tags: type == 'movie' ? const ['Action', 'Thriller'] : const ['Drama', 'Mystery'],
    );
  }

  static List<PlayTitle> get popular => titles;
  static List<PlayTitle> get newReleases => titles.reversed.toList();
  static List<PlayTitle> get movies => titles.where((t) => t.type == 'movie').toList();
  static List<PlayTitle> get series => titles.where((t) => t.type == 'series').toList();
}
