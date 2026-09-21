# Video Playback

Playback must be provider-neutral at the app boundary.

The app asks `PlaybackService` for a playable descriptor. The service does not expose provider credentials to the UI.

Playback capabilities:
- adaptive HLS where available
- quality selection when the provider exposes it
- subtitles
- audio tracks where available
- seek/rewind
- fullscreen
- resume position
- playback progress reporting
- error/retry states

For protected content, the server creates short-lived playback authorization. The client receives only the URL/token needed by the player.

Playback progress should be throttled and flushed at meaningful events such as pause, backgrounding, completion, and periodic intervals.
