# Google Play app-content declaration draft

Prepared from the Android manifest, Flutter dependencies, client source, and Kanvas API source on
15 August 2026. These are draft inputs, not submitted legal attestations.

## Ads

- **Contains ads:** No.
- Evidence: no advertising SDK dependency and no advertising-ID permission.

## App access

- **Restricted functionality:** Yes; saved sessions and profiles require an account.
- Use the non-secret instructions in [`app-access.md`](app-access.md).
- Add a dedicated review account directly in Play Console before review.

## Target audience

- Recommended age group: **18 and over**.
- Not designed for children and should not be presented as a Families app.
- Reason: dynamic AI-generated art-market research, valuations, provenance and acquisition guidance.

## Content rating questionnaire preparation

- App type: utility/reference and AI art advisory; not a game.
- Violence, sexual content, controlled substances, gambling, profanity supplied by the publisher: None.
- Users do not communicate with one another inside the app.
- Users can generate and view dynamic AI text. They can flag an AI response in-app.
- Users can deliberately create a public read-only link for a selected chat; there is no public feed,
  discovery directory, commenting, or follower system.
- No in-app purchases, cash prizes, wagering, or location sharing.
- Submit the live questionnaire honestly and accept the rating calculated by IARC.

## Generative AI

- The app is a text-to-text generative-AI application.
- A **Report response** control appears beneath AI messages.
- Report categories: unsafe/harmful, offensive, misleading/inaccurate, and other.
- Reports are sent to the Kanvas API for safety review.
- Store copy and privacy policy warn that AI results may be incomplete or incorrect.

## Financial features

- Conservative recommended selection: **Financial advice**.
- Explanation: Kanvas gives informational art-market valuation, acquisition and collection guidance.
- It does **not** provide banking, loans, payments, wallets, money transfer, cryptocurrency, NFTs,
  securities trading, crowdfunding, insurance, brokerage, custody, purchases, or portfolio execution.
- No personal-loan licence documentation should be applicable.
- Re-check the exact live categories before saving; use **Other** additionally only if Play Console's
  wording requires it for art-market advisory.

## Other app-content declarations

- News or magazine app: No.
- Government app or government-information app: No.
- Health app: No.
- COVID-19 features: No.
- Ads ID: Not used.
- Sensitive/restricted Android permissions: None; release manifest requests internet access only.

## Data safety

### Collection and security

- App collects user data: **Yes**.
- Data is encrypted in transit: **Yes**, production API and service-provider calls use HTTPS.
- Users can request deletion: **Yes**.
- In-app deletion path: **Profile & Preferences → Privacy & account deletion → Delete account**.
- Web deletion resource: `https://kanvas.ai/account-deletion`.
- Independent security review: **No**, unless a qualifying review is completed before submission.
- Data sharing: provisionally **No** under Google's service-provider exception. The publisher must
  confirm that Google Sign-In, xAI, Exa, Postmark and infrastructure providers qualify as processors/
  service providers under the current Play definition before certifying this answer.

### Data types to declare

| Google Play data type | Collected | Required/optional | Purposes |
|---|---:|---|---|
| Personal info — name | Yes | Optional except when supplied for an account | Account management, app functionality |
| Personal info — email address | Yes | Required for an account; anonymous use available | Account management, authentication, developer communications |
| Personal info — phone number | Yes | Optional profile field | Account management, app functionality |
| Location — approximate location | Yes | Optional, user-entered country/city only | Personalisation, app functionality |
| Messages — other in-app messages | Yes | Required when using AI chat | App functionality, saved history, safety |
| Other user-generated content | Yes | Optional reports, support messages and deliberately shared chats | App functionality, developer communications, safety |
| App activity — app interactions | Yes | Required when using sessions and reports | App functionality, analytics limited to service operation, fraud/security |
| Device or other IDs | Conservatively yes | Automatic for network requests | Security, fraud prevention, diagnostics |

### Data not collected by the Android app

- Precise device location
- Contacts, calendars, SMS or call logs
- Photos, videos, camera or microphone recordings
- Health and fitness data
- Payment card, bank-account or transaction data
- Advertising ID
- Installed-app inventory

### Processing notes

- Account tokens are stored locally using platform secure storage.
- Language preference may be stored locally.
- Prompts, limited recent chat context and generated search queries may be processed by xAI and Exa
  to answer a request.
- Google processes identity data when the user chooses Google Sign-In.
- Postmark processes email data for service emails and selected notifications.
- A shared chat becomes readable to anyone with its unguessable link until the underlying chat or
  account is deleted.

## Privacy URLs

- Privacy policy: `https://kanvas.ai/privacy`
- Account deletion: `https://kanvas.ai/account-deletion`
- Controller: Predictive Labs Ltd, company 14857334, 155 Minories Street, Suite 275, London EC3N 1AD,
  United Kingdom.
- Privacy contact: `info@predictivelabs.ai`

The privacy policy is a publisher draft and should receive legal review before production submission.
