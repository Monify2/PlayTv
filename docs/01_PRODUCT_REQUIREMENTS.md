# Product Requirements

## Catalogue
Support movies and series. Series contain seasons; seasons contain episodes. Titles can have genres, people/cast, studios/networks, posters, backdrops, trailers, synopsis, tags, ratings, release dates, and recommendation metadata.

## Home
Home can contain a featured hero, Continue Watching, Popular, New Releases, Movies, Series, and personalized/recommended rows. Content must be fetched from the backend rather than hard-coded for production.

## Search
Search supports titles and can expose filters such as movie/series, genre, popularity, newest, and rating. Search results must support loading, empty, error, and retry states.

## Watchlist
Users can add/remove titles from My List. The state must stay synchronized with the backend and update the UI immediately where safe.

## Continue Watching
Playback progress is stored per user and per title/episode. The client resumes from the stored position and updates progress during playback without excessive network traffic.

## Accounts
Support sign-in, sign-up, sign-out, current-user profile, and authenticated data access through Supabase.

## Premium
Plans: weekly $1, monthly $3, yearly $26 as base plan values. Localized prices are represented by backend `plan_prices`; do not perform a live foreign-exchange conversion at checkout.

Premium removes ads, permits higher streaming/download quality, and enables premium offline behavior according to entitlement rules.
