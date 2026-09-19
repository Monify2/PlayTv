import { SignJWT, importPKCS8 } from 'npm:jose@5.10.0';
import { ProviderSource, VideoProvider, requirePlaybackId } from './provider.ts';

export class MuxAdapter implements VideoProvider {
  readonly name = 'mux';

  async getPlayback(source: ProviderSource) {
    const playbackId = requirePlaybackId(source);
    const accessPolicy = (source.access_policy ?? 'public').toLowerCase();
    let token: string | null = null;
    let expiresAt: string | null = null;

    if (accessPolicy === 'private') {
      const keyId = required('MUX_SIGNING_KEY_ID');
      const privateKeyPem = required('MUX_SIGNING_PRIVATE_KEY');
      const now = Math.floor(Date.now() / 1000);
      const exp = now + 300;
      const key = await importPKCS8(privateKeyPem, 'RS256');
      token = await new SignJWT({})
        .setProtectedHeader({ alg: 'RS256', kid: keyId })
        .setSubject(playbackId)
        .setAudience('v')
        .setIssuedAt(now)
        .setExpirationTime(exp)
        .sign(key);
      expiresAt = new Date(exp * 1000).toISOString();
    }

    const url = `https://stream.mux.com/${encodeURIComponent(playbackId)}.m3u8${token ? `?token=${encodeURIComponent(token)}` : ''}`;
    return {
      url,
      provider: this.name,
      provider_asset_id: source.provider_asset_id ?? null,
      playback_id: playbackId,
      title: source.title ?? null,
      expires_at: expiresAt,
    };
  }
}

function required(name: string): string {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing server secret: ${name}`);
  return value;
}
