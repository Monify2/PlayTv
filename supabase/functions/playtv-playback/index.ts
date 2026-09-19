import { createClient } from 'npm:@supabase/supabase-js@2.57.2';
import { getProvider } from './providers/index.ts';
import type { ProviderSource } from './providers/provider.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const authHeader = request.headers.get('Authorization');
    if (!authHeader?.startsWith('Bearer ')) return json({ error: 'Unauthorized' }, 401);

    const supabase = createClient(
      required('SUPABASE_URL'),
      required('SUPABASE_SERVICE_ROLE_KEY'),
      { global: { headers: { Authorization: authHeader } } },
    );

    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) return json({ error: 'Unauthorized' }, 401);

    const body = await request.json();
    const titleId = body?.title_id?.toString();
    const episodeId = body?.episode_id?.toString();
    if (!titleId) return json({ error: 'title_id is required' }, 400);

    // This RPC is the single database authorization boundary. It is expected
    // to enforce published state and the user's current streaming entitlement.
    const { data, error } = await supabase.rpc('get_playback_sources', {
      p_title_id: titleId,
      p_episode_id: episodeId ?? null,
    });
    if (error) throw error;

    const rows = Array.isArray(data) ? data : [];
    const source = rows[0] as ProviderSource | undefined;
    if (!source) return json({ error: 'Playback is not available' }, 404);

    const provider = getProvider(source.provider);
    const descriptor = await provider.getPlayback(source);
    return json(descriptor, 200);
  } catch (error) {
    console.error(error);
    return json({ error: error instanceof Error ? error.message : 'Playback failed' }, 500);
  }
});

function required(name: string): string {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing environment variable: ${name}`);
  return value;
}

function json(body: unknown, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
