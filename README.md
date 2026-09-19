# PlayTv

PlayTv is a premium streaming client built with Flutter and Supabase. This repository is intentionally built for the same workflow used for the OUTIS project: source code in Git, Flutter/Android tooling in GitHub Actions, and Termux used for Git/source management.

## What is included

- Graphite + black cinematic mobile UI with electric-green primary states.
- Home, Movies, TV Series, Search, Downloads and Profile navigation.
- Movie/series detail pages, seasons and episode surfaces.
- Watchlist and continue-watching API integration.
- Supabase authentication and Edge Function API integration.
- Provider-neutral playback service with a swappable FastPix/Mux backend architecture.
- Demo catalogue fallback so the UI can be explored before the backend is populated.
- GitHub Actions Android build and test workflow.
- Full product and architecture documentation in `docs/`.

## Local/Termux workflow

Termux does not need Flutter or the Android SDK for the normal build workflow.

```bash
unzip PlayTv-final.zip
cd PlayTv
git init
git add .
git commit -m "Build PlayTv core app"
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY
git push -u origin main
```

GitHub Actions creates the Android project files when the workflow runs, then performs dependency installation, formatting checks, analysis, tests and a release APK build.

## Optional local Flutter checks

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

## Supabase build values

Configure these as GitHub Actions repository variables/secrets:

- `SUPABASE_URL` — repository variable
- `SUPABASE_PUBLISHABLE_KEY` — repository secret

Supabase's current Flutter documentation uses `Supabase.initialize(url:, publishableKey:)` for client apps. Publishable keys are intended for shipped client code; secret keys remain server-side. citeturn0search0turn0search8

## Backend

The app calls the PlayTv Edge Functions:

- `playtv-api`
- `playtv-playback`
- `playtv-download`

The client sends the authenticated user's bearer token to protected functions. Supabase documents Edge Function invocation as requiring an Authorization header. citeturn0search11

## Android build

The GitHub workflow generates the Android platform wrapper when necessary, runs checks, builds a release APK and uploads it as an artifact. Flutter's Android release documentation covers both APK and app bundle builds. citeturn0search10

## Video provider architecture

FastPix is the initial provider, while Mux is implemented as a swappable first-class adapter. The Flutter player only consumes the provider-neutral playback descriptor returned by `playtv-playback`. Provider credentials and signing keys remain server-side. See `docs/19_PROVIDER_ABSTRACTION.md` and `docs/23_MUX_PROVIDER.md`.
# PlayTv
