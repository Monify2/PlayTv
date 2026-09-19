# Security

## Never ship
- Supabase service-role key
- FastPix secret key
- FastPix signing private key
- webhook secret
- TMDB private credentials
- payment provider secret

## Client-safe
The Supabase publishable key is intended for client applications, with access controlled by authentication/RLS and server policies.

## Server authority
The server decides whether a user can stream, download, access premium features, and receive protected playback credentials.

Validate ownership for watch progress, watchlists, downloads, devices, and profile updates. Protect role/is_active fields from client self-escalation.
