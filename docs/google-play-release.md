# Google Play release pipeline

The Play workflow builds a signed Android App Bundle on demand and can upload it only to the
Google Play **internal** track. It has no production-track path.

## Current release identity

- Package: `ai.kanvas.mobile`
- Version name: `1.0.2`
- Target SDK in the last audited CI artifact: 36
- Upload certificate SHA-1: `2B:37:B8:6D:5A:B8:F3:75:6E:C8:3C:05:9F:95:88:65:2D:C5:3B:E8`
- Upload certificate SHA-256: `68:A4:E3:3D:4B:35:F3:45:20:63:BC:62:30:ED:56:22:E6:AA:A0:47:13:59:C4:E0:54:E0:24:6A:E7:6C:EC:2E`

Release version codes use the UTC Unix timestamp. This is monotonically increasing and remains
below Google Play's `2100000000` limit until 2036; replace the scheme before then.

## GitHub configuration

Release signing uses the existing encrypted repository secrets:

- `KEYSTORE_BASE64`
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `STORE_PASSWORD`

Google authentication uses GitHub OIDC and Google Workload Identity Federation instead of a
downloadable JSON key. The workflow expects these repository variables:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_PLAY_SERVICE_ACCOUNT`

The service account is `github-actions-deploy@kanvas-mobile-4569f.iam.gserviceaccount.com`.

## One-time Play Console bootstrap

Google's publishing API cannot create the first app record or perform the first upload.
After account verification completes:

1. Create **Kanvas** in Play Console with package `ai.kanvas.mobile`.
2. Enrol in Play App Signing and upload the first signed AAB manually to internal testing.
3. In **Users and permissions**, invite the service-account email above.
4. Give it app-specific permission to view the app and release builds to testing tracks only.
   Do not grant production, financial, or account-administration permissions.
5. Run **Prepare or Deploy Google Play Internal** with `upload_to_play=false` first and inspect
   the signed AAB artifact.
6. Run it with `upload_to_play=true`; leave `release_status=draft` until the internal release is
   ready. Select `completed` only to make that internal release available to configured testers.

The `upload_to_play` switch is intentionally false by default. Identity, policy declarations,
store listing, data safety, and production review remain human-controlled Play Console gates.
