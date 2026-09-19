export type ProviderSource = {
  id: string;
  provider: string;
  provider_asset_id?: string | null;
  provider_playback_id?: string | null;
  provider_status?: string | null;
  provider_metadata?: Record<string, unknown> | null;
  access_policy?: string | null;
  playback_url?: string | null;
  download_url?: string | null;
  title?: string | null;
};

export type PlaybackDescriptor = {
  url: string;
  provider: string;
  provider_asset_id?: string | null;
  playback_id?: string | null;
  title?: string | null;
  expires_at?: string | null;
  subtitles?: unknown[];
  audio_tracks?: unknown[];
};

export interface VideoProvider {
  readonly name: string;
  getPlayback(source: ProviderSource): Promise<PlaybackDescriptor>;
  getDownload?(source: ProviderSource): Promise<{ url: string; expires_at?: string | null }>;
}

export function requirePlaybackId(source: ProviderSource): string {
  if (!source.provider_playback_id) {
    throw new Error(`${source.provider} source has no playback ID`);
  }
  return source.provider_playback_id;
}
