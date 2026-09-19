# FastPix Provider Adapter

FastPix is the **initial/default provider**, not the permanent provider dependency of PlayTv.

The FastPix implementation lives behind `VideoProvider` in:

`supabase/functions/playtv-playback/providers/fastpix.ts`

FastPix supplies a playback ID for an asset and supports HLS playback. Public playback uses the provider's HLS URL; private playback adds a short-lived JWT generated server-side. FastPix documents the HLS URL as `https://stream.fastpix.com/{playbackId}.m3u8` and private playback as the same URL with a JWT token. citeturn1search0turn2search0

The current FastPix signing payload used by the adapter follows the documented signing-key fields: `kid`, `aud` set to `media:{playbackId}`, `iss` set to `fastpix.com`, `sub` set to the workspace ID, plus `iat` and `exp`. citeturn3search0

## Server-only secrets

- `FASTPIX_ACCESS_TOKEN_ID`
- `FASTPIX_SECRET_KEY`
- `FASTPIX_SIGNING_KEY_ID`
- `FASTPIX_SIGNING_PRIVATE_KEY`
- `FASTPIX_WORKSPACE_ID`
- `FASTPIX_WEBHOOK_SECRET`

Never place these values in Flutter source, `--dart-define`, or the Android artifact.
