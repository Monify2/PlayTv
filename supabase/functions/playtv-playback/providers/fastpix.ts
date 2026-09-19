import { SignJWT, importPKCS8 } from 'npm:jose@5.10.0';
import { ProviderSource, VideoProvider, requirePlaybackId } from './provider.ts';

export class FastPixAdapter implements VideoProvider {
  readonly name = 'fastpix';

  async getPlayback(source: ProviderSource) {
    const playbackId = requirePlaybackId(source);
    const accessPolicy = (source.access_policy ?? 'public').toLowerCase();
    let token: string | null = null;
    let expiresAt: string | null = null;

    if (accessPolicy === 'private') {
      const keyId = required('FASTPIX_SIGNING_KEY_ID');
      const privateKeyPem = required('FASTPIX_SIGNING_PRIVATE_KEY');
      const workspaceId = required('FASTPIX_WORKSPACE_ID');
      const now = Math.floor(Date.now() / 1000);
      const exp = now + 300;
      const key = await importPKCS8(normalizePem(privateKeyPem), 'RS256');
      token = await new SignJWT({ aud: playbackId })
        .setProtectedHeader({ alg: 'RS256', kid: keyId, typ: 'JWT' })
        .setIssuer('fastpix.io')
        .setSubject(workspaceId)
        .setIssuedAt(now)
        .setExpirationTime(exp)
        .sign(key);
      expiresAt = new Date(exp * 1000).toISOString();
    }

    const url = `https://stream.fastpix.io/${encodeURIComponent(playbackId)}.m3u8${token ? `?token=${encodeURIComponent(token)}` : ''}`;
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

function normalizePem(value: string): string {
  return value.includes('\\n') ? value.replace(/\\n/g, '\n') : value;
}

function required(name: string): string {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing server secret: ${name}`);
  return value;
}
