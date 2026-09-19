# API Contract

The primary client API is the `playtv-api` Edge Function.

Expected routes:
- GET /me
- GET /home
- GET /titles
- GET /titles/:id
- GET /genres
- GET /search
- GET /people
- GET /people/:id
- GET /watchlist
- POST /watchlist
- DELETE /watchlist/:titleId
- GET /progress
- POST /progress
- GET /downloads
- GET /plans
- GET /plans/prices?currency=XXX

Playback is delegated to `playtv-playback`.
Downloads are delegated to `playtv-download`.

The client should send the current Supabase access token as the Bearer token and the publishable key where required by the Edge Function gateway. Never substitute a service-role key.
