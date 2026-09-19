# Mux Provider Adapter

Mux is a first-class alternate provider. It implements the same server-side `VideoProvider` contract as FastPix.

The playback adapter lives in:

`supabase/functions/playtv-playback/providers/mux.ts`

Mux assets expose playback IDs. Public playback uses:

`https://stream.mux.com/{PLAYBACK_ID}.m3u8`

Signed playback uses the same HLS URL with a JWT. Mux documents `public`, `signed`, and `drm` playback policies; PlayTv's common provider contract keeps the policy in `video_sources.access_policy` and lets the provider adapter handle the provider-specific authorization. citeturn0search0turn0search4

## Server-only secrets

- `MUX_TOKEN_ID`
- `MUX_TOKEN_SECRET`
- `MUX_SIGNING_KEY_ID`
- `MUX_SIGNING_PRIVATE_KEY`

Mux API credentials are used only by administrative provider functions. The signing private key is used only by the playback Edge Function to mint short-lived tokens.

## Switching between providers

The app does not select FastPix or Mux. The server selects the adapter from the `video_sources.provider` value. This allows the same title/episode to move between providers without changing Flutter code.
