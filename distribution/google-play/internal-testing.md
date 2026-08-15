# Internal testing plan

## Track

- Start with Google Play **Internal testing** only.
- Use the signed AAB from the audited GitHub Actions run.
- Keep release status as **Draft** until the artifact, listing, and declarations have been reviewed.
- Do not promote or roll out to production without separate explicit approval.

## Tester list

Create a Play Console email list named `kanvas-internal` and add only named testers who have agreed to
test the app. Keep personal email addresses in Play Console rather than source control.

Suggested initial roles:

- Product owner/account owner
- Android 12–13 tester
- Android 14 tester
- Android 15–16 tester
- One first-time user who has not seen the product

## Acceptance checks

- Install through the Play opt-in link, not a sideloaded APK.
- Confirm package `ai.kanvas.mobile`, version name/code, and Play App Signing state.
- Test clean launch, anonymous chat, email registration, email login, Google Sign-In, logout, and token
  restoration.
- Test artist research, auction lookup, valuation, and provenance prompts against the production API.
- Confirm that AI output can be reported from inside the app.
- Confirm profile edits and notification preferences.
- Confirm chat deletion, account deletion, and shared-link invalidation using a disposable test account.
- Review the automated pre-launch report for crashes, accessibility, security, and device compatibility.
- Check English store copy and every uploaded graphic on a phone-sized Play Store view.

Record device model, Android version, tester, build version code, result, and issue link for each run.
