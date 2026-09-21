# Supabase Backend Contract

Project reference: PlayTv Supabase project.

Primary tables already planned include:
- profiles
- genres
- people
- studios
- titles
- title_genres
- title_people
- seasons
- episodes
- video_sources
- watch_progress
- watchlists
- downloads
- subscription_plans
- plan_prices
- subscriptions
- entitlements
- payment_events
- ad_rules
- devices
- video_provider_events
- tmdb_config

Important security rule: client applications receive only publishable/anonymous credentials. Provider secrets, payment secrets, signing keys, webhook secrets, and privileged service-role credentials remain server-side.

Authentication is Supabase Auth. Row-level security and security-definer helpers protect user-owned data and entitlement checks.
