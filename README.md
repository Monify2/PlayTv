# PlayTv

PlayTv is a Flutter streaming client backed by Supabase, TMDB and Bunny Stream.

## Current architecture

- Flutter mobile client
- Supabase Auth, database and Edge Functions
- Bunny Stream signed HLS playback
- Bunny-authorized offline downloads in the app-private sandbox
- TMDB catalogue/import through the Supabase `playtv-tmdb` function
- Subscription, entitlement and ad architecture
- Dark graphite UI with darker green PlayTv accent
- Search from the global top-bar search action
- Functional profile/menu settings
- No guest/demo mode
- No project tests

## Supabase

The release build receives:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`

from GitHub Actions Secrets first, with repository Variables as fallback.

The TMDB API key is checked as:

- `TMDB_API_KEY`

but is deliberately not embedded into the Flutter APK. TMDB credentials belong in the Supabase Edge Function environment so the client does not expose the secret.

## GitHub Actions

The workflow:

1. Generates the Android platform.
2. Sets the device application name to `PlayTv`.
3. Ensures Android internet permission.
4. Loads the Supabase build configuration.
5. Verifies the TMDB secret exists.
6. Runs Flutter analysis.
7. Builds a release APK.
8. Uploads `PlayTv-release.apk` as an artifact.
9. Creates a GitHub Release for pushes/manual builds.

## Run from Termux

Flutter/Android SDK are not required locally for the normal workflow. Commit and push to GitHub, then download the generated APK from the Actions artifact or GitHub Release.

Do not paste credentials into source files or chat.


## Download quality
PlayTv includes a quality selector for movie and episode downloads. Free users unlock HD/Full HD/4K with a rewarded ad; premium users use their entitlement without the ad step. Server-side authorization remains authoritative.
