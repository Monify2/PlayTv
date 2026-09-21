# Download Quality and Rewarded Ads

PlayTv now presents a quality selector before every movie or episode download.

## Free users

- Data Saver (360p) and Standard (480p) are lower-quality options.
- HD (720p), Full HD (1080p), and Ultra HD (4K, when the asset exists) are high-quality options.
- Selecting a high-quality option requires a rewarded ad before the download request is authorized.
- The rewarded-ad completion is sent to the download backend as `reward_ad_completed: true` only after the user completes the reward flow.
- If no reward ad is available or the user cancels it, the high-quality download does not start.

## Premium users

Premium users can select the quality allowed by their entitlement without a rewarded ad. The backend remains authoritative over the maximum quality actually available to the account and the media asset.

## Backend requirement

`playtv-download` must enforce the same rule server-side:

1. Determine the authenticated user's entitlement.
2. For free users, allow lower-quality downloads according to the free-tier policy.
3. For free users requesting HD/Full HD/4K, require a valid rewarded-ad completion signal before issuing the Bunny download URL.
4. For premium users, enforce their entitlement's maximum download quality.
5. Never trust the Flutter client's requested quality or reward flag by itself.
6. Issue the Bunny URL only after all authorization checks pass.

The Flutter app does not embed provider secrets and does not bypass server-side entitlement checks.
