# Flutter Implementation

Use a maintainable Flutter structure:

```text
lib/
  core/
  models/
  services/
  widgets/
  screens/
```

Centralize theme and configuration. Keep API URLs and function names in configuration. Use typed models rather than passing raw dynamic maps through the whole UI.

Use image caching for poster/backdrop assets. Use responsive layouts so the same screens remain usable on small and larger Android devices.

Player implementation should use the project's chosen Flutter video package and a service boundary so the UI is not coupled to provider internals.

Do not add dependencies without a clear reason. Keep dependencies current and compatible with the Flutter stable channel used by CI.
