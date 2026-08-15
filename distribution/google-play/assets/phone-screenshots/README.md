# Phone screenshots

Upload at least four portrait screenshots showing the real production-connected app at a minimum of
1080×1920. Recommended sequence:

1. `01-ai-advisors.png` — welcome screen and specialist prompt cards.
2. `02-artist-research.png` — a real artist-research answer with source context.
3. `03-auction-insights.png` — a real auction/market answer and tool activity.
4. `04-valuation-results.png` — a real valuation answer or chart result.
5. `05-profile-controls.png` — profile preferences and privacy/account controls.

Do not upload browser chrome, debug banners, test credentials, personal email addresses, or fabricated
responses. Re-capture these from the signed Android build before production if provisional Flutter-web
captures are used during preparation.

## Current asset provenance

The four PNGs in this directory were captured on 15 August 2026 from the actual Flutter application at
a 360×640 logical phone viewport while it was connected to `https://api.kanvas.ai`. The artist,
market-analysis and valuation screenshots contain real responses from the production API. They were
mechanically scaled to 1080×1920 without adding or altering UI content.

They are suitable for preparing the internal-test listing. The installed Android emulator crashed on
this host before boot, so recapturing the same screens from the signed Android build remains mandatory
before production submission.
