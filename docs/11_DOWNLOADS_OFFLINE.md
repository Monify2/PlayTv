# Downloads and Offline Playback

Downloads are user-owned records associated with titles or episodes.

Free users require a reward ad before an allowed download and receive lower-quality download options. Premium users receive higher quality according to entitlement.

The download flow should:
1. Verify authentication.
2. Verify entitlement and content authorization server-side.
3. Verify a provider-ready download URL exists.
4. Create/update a download record.
5. Download with progress reporting.
6. Store the file in an app-controlled location.
7. Maintain status: queued/downloading/ready/failed/deleted as appropriate.
8. Provide offline organization and playback.

Never treat a client-provided URL as sufficient authorization.
