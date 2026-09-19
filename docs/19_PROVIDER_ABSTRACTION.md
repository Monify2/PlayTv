# Provider Abstraction

PlayTv uses a **swappable video-provider architecture**. FastPix is the initial provider, but it is not part of the app's permanent playback contract. Mux is a first-class alternate provider and additional providers can be added without changing Flutter screens.

## Boundary

```text
Flutter UI
   |
   v
PlaybackService
   |
   v
playtv-playback Edge Function
   |
   v
ProviderRegistry
   |-----------------------|
   v                       v
FastPixAdapter          MuxAdapter
   |                       |
 FastPix API/CDN         Mux API/CDN
```

The Flutter app receives a common `PlaybackDescriptor`. It never constructs a FastPix or Mux URL and never receives provider credentials.

## Provider contract

The server-side `VideoProvider` contract covers:

- `createMedia`
- `getMedia`
- `getPlayback`
- `createPlaybackToken`
- `getDownload`
- `deleteMedia`

Playback currently dispatches through `getPlayback`. Administrative provider operations belong in the provider admin function and must use the same registry.

## Database selection

`video_sources.provider` selects the adapter:

```text
fastpix -> FastPixAdapter
mux     -> MuxAdapter
```

Provider-specific IDs remain in `video_sources`:

- `provider_asset_id`
- `provider_playback_id`
- `provider_upload_id`
- `provider_status`
- `provider_metadata`
- `access_policy`

## Switching a title

To move a title from FastPix to Mux, create/activate a Mux `video_sources` row for the same title/episode and update its priority/active state. The Flutter application does not change.

## Security

Provider API credentials and signing keys are server-only. Signed playback URLs are generated in the Edge Function. FastPix private playback uses a short-lived JWT with the playback ID as the audience. Mux signed playback uses a short-lived JWT with the playback ID as the subject and `v` as the video audience. These details match the providers' current secure playback documentation.
