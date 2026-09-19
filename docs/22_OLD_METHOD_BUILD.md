# PlayTv — Old Method Build Workflow

PlayTv follows the same practical pattern used for the OUTIS project: write the complete Flutter source in the repository, use Termux for Git operations, and let GitHub Actions provide Flutter and Android build tooling.

The repository does not require Flutter to be installed in Termux. GitHub Actions creates the Android platform wrapper when it runs, installs Flutter stable, fetches packages, formats/analyzes/tests the source and builds the release APK.

The application is configured for Supabase through `--dart-define` values. The client uses only the publishable key. Protected provider credentials, FastPix signing material, TMDB API keys, payment secrets and webhook secrets belong in Supabase Edge Function secrets, not in this repository or the APK.
