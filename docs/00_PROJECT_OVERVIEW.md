# PlayTv — Project Overview

PlayTv is a premium mobile streaming platform. The application provides movies, TV series, seasons, episodes, search, watchlists, continue-watching, playback, downloads, subscriptions, advertising, profiles, and settings.

The architecture is deliberately provider-agnostic. Supabase is the application backend and authorization/data layer. FastPix is the initial video provider, but the app must not be designed so deeply around FastPix that another provider cannot be introduced later.

## Primary surfaces
- Home
- Movies
- Series
- Search
- My List / Watchlist
- Continue Watching
- Downloads
- Player
- Profile / Settings
- Subscription / Premium

## Development model
automated source workflow operates locally in the repository. GitHub Actions provides reproducible analysis, tests, Android APK builds, and later release builds. Repository instructions live in `AGENTS.md`; detailed specifications live under `docs/`.
