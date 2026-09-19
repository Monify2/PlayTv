# Build and Release

GitHub Actions is the canonical build environment because local Termux may not contain Flutter/Android SDK.

## Pull request checks
- install Flutter stable
- dependencies
- formatting
- analyzer
- tests

## Main branch build
After checks pass:
- build Android APK for easy testing
- upload APK artifact
- optionally build Android App Bundle for release

Flutter's Android release documentation identifies App Bundle as the preferred Play Store format; APK remains useful as a direct test artifact.

Client-safe build defines may include:
- SUPABASE_URL
- SUPABASE_PUBLISHABLE_KEY

Do not pass server secrets to Flutter builds.
