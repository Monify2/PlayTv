# Authentication and Subscriptions

## Auth
Use Supabase Auth. Anonymous browsing may be supported where backend policy permits, but user-owned features require authentication.

## Plans
- Weekly: $1
- Monthly: $3
- Yearly: $26

Backend `plan_prices` stores localized currency values. The app should request prices from the backend rather than calculating them from a live FX rate.

## Entitlements
Entitlements determine access to:
- ad-free playback
- maximum streaming quality
- maximum download quality
- offline playback

The client may display entitlement state, but server-side authorization remains authoritative.
