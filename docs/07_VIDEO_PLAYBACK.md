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


## Provider neutrality

The client must never construct vendor-specific URLs. `PlaybackService` calls `playtv-playback`, which dispatches to the adapter selected by `video_sources.provider`. Current adapters are FastPix and Mux.

The provider-neutral response includes the playable HLS URL, provider name, provider IDs, expiry (when signed), and optional subtitle/audio track descriptors.
