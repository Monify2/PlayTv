# TMDB Catalogue Pipeline

TMDB is the metadata discovery/import source, not the application's video host.

Pipeline:

```text
TMDB Search
   -> Import metadata
   -> Draft title
   -> Edit/normalize metadata
   -> Attach provider video
   -> Validate playback
   -> Publish
   -> Live catalogue
```

Supported import concepts include movie and TV metadata, people, genres, studios/networks, seasons, and episodes.

The PlayTv content type for TV is `series`; do not accidentally map TMDB's `tv` string directly into a database enum if that enum expects `series`.

TMDB API credentials remain server-side.
