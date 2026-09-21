# App Architecture

Flutter is the presentation/client layer. Supabase is the backend. Edge Functions expose protected application operations. The client must not directly hold privileged provider credentials.

Suggested layers:

```text
UI/screens/widgets
        |
Application services/controllers
        |
API/auth/playback/download services
        |
Supabase Edge Functions + authenticated database RPCs
        |
PostgreSQL / provider adapters / external services
```

Keep models independent from transport details where practical. Use DTO parsing at the API boundary. Handle API errors explicitly.

## Core client services
- AuthService
- ApiService
- PlaybackService
- DownloadService
- SubscriptionService
- SupabaseService
- optional Image/Cache service

## Navigation
Use a stable shell with bottom destinations: Home, Movies, Series, Downloads, Profile. Search and detail/player routes sit above the shell.
