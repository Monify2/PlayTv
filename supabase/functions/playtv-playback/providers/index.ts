import { VideoProvider } from './provider.ts';
import { FastPixAdapter } from './fastpix.ts';
import { MuxAdapter } from './mux.ts';

const providers: Record<string, VideoProvider> = {
  fastpix: new FastPixAdapter(),
  mux: new MuxAdapter(),
};

export function getProvider(name: string): VideoProvider {
  const provider = providers[name.toLowerCase()];
  if (!provider) throw new Error(`Unsupported video provider: ${name}`);
  return provider;
}
