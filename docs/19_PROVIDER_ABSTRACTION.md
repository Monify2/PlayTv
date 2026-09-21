# Provider Abstraction

Application-level provider interface:

```text
VideoProvider
  createMedia
  getMedia
  getPlayback
  createPlaybackToken
  getDownload
  deleteMedia
```

Initial implementation:
- FastPixAdapter

Future implementations may include:
- MuxAdapter
- another HLS/video provider

Provider-specific identifiers live in `video_sources` and server-side metadata. UI code should only consume provider-neutral playback/download descriptors.
