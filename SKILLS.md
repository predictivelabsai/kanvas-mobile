# SKILLS.md

Deployment, testing, and app store registration playbook for Kanvas Mobile.

---

## Table of Contents

1. [Regression Testing](#1-regression-testing)
2. [Playwright E2E Testing](#2-playwright-e2e-testing)
3. [Flutter Platform Setup](#3-flutter-platform-setup)
4. [Google Play — Full Registration & Deployment](#4-google-play--full-registration--deployment)
5. [Apple App Store — Full Registration & Deployment](#5-apple-app-store--full-registration--deployment)
6. [TestFlight (iOS Beta)](#6-testflight-ios-beta)
7. [Google Play Internal & Closed Testing](#7-google-play-internal--closed-testing)
8. [Firebase App Distribution (Android)](#8-firebase-app-distribution-android)
9. [CI/CD Pipeline](#9-cicd-pipeline)
10. [Environment Configuration](#10-environment-configuration)
11. [Google Sign-In Credentials Setup](#11-google-sign-in-credentials-setup)

---

## 1. Regression Testing

### Unit Tests

All unit tests live under `test/unit/` and run without a device or emulator.

```bash
# Generate mocks first (required after model/service changes)
dart run build_runner build --delete-conflicting-outputs

# Run all unit tests
flutter test test/unit/

# Run a single test file
flutter test test/unit/models/chat_test.dart

# Run tests matching a name pattern
flutter test --name "SSE event parsing"

# Run with coverage
flutter test --coverage
lcov --remove coverage/lcov.info 'lib/l10n/*' -o coverage/filtered.info
genhtml coverage/filtered.info -o coverage/html
```

**Test categories:**

| Directory | What it covers |
|-----------|---------------|
| `test/unit/models/` | JSON round-trip, computed properties, null safety for all model classes |
| `test/unit/services/` | Mocked Dio responses for auth, SSE parser for all 8 event types |
| `test/unit/utils/` | Price formatting, email/password/required validators |

### Widget Tests

Widget tests render individual components in isolation. No network calls — providers that trigger API calls must be overridden.

```bash
flutter test test/widget/

# Single widget test
flutter test test/widget/login_screen_test.dart
```

**Key pattern:** Widgets that watch network-backed providers (e.g., `agentsProvider`) need overrides in the test wrapper to prevent pending timer failures:

```dart
ProviderScope(
  overrides: [
    agentsProvider.overrideWith((ref) async => <AgentOut>[]),
  ],
  child: MaterialApp(home: Scaffold(body: widgetUnderTest)),
)
```

### Integration Tests (in-process)

Tests under `test/integration/` exercise multi-widget flows (auth, chat state machine, navigation) using real providers with mocked data. These still run via `flutter test` (no device needed).

```bash
flutter test test/integration/
```

### On-Device Integration Tests

For full device integration tests, create files under `integration_test/` (top-level directory, not `test/`). These run on a real device or emulator.

```bash
mkdir -p integration_test

flutter test integration_test/app_test.dart
flutter test integration_test/ -d <device-id>
```

**Template for on-device tests:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kanvas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full login and chat flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Kanvas AI Advisor'), findsOneWidget);
  });
}
```

### Adding New Tests: Checklist

1. **New model** → add `test/unit/models/<name>_test.dart` with `fromJson` round-trip, computed properties, null/optional field handling
2. **New service** → add `test/unit/services/<name>_test.dart`, annotate with `@GenerateMocks([ApiClient])`, run `dart run build_runner build`
3. **New screen/widget** → add `test/widget/<name>_test.dart`, override any async providers
4. **New user flow** → add `test/integration/<name>_flow_test.dart` for the state machine logic

---

## 2. Playwright E2E Testing

Playwright tests run against the **companion web app** (`../kanvas/`) but can also validate the API contract the mobile app depends on.

### Setup

```bash
npm init -y
npm install -D @playwright/test
npx playwright install
```

### API Contract Tests

Create `e2e/api-contract.spec.ts` to verify every endpoint the mobile app calls:

```typescript
import { test, expect } from '@playwright/test';

const BASE = process.env.API_BASE_URL || 'https://kanvas.ai/api';

test.describe('API contract for mobile app', () => {
  let token: string;

  test.beforeAll(async ({ request }) => {
    const res = await request.post(`${BASE}/auth/token`, {
      data: { email: process.env.TEST_EMAIL, password: process.env.TEST_PASSWORD },
    });
    expect(res.ok()).toBeTruthy();
    const body = await res.json();
    token = body.token;
  });

  test('GET /agents returns array with expected shape', async ({ request }) => {
    const res = await request.get(`${BASE}/agents`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    expect(res.ok()).toBeTruthy();
    const agents = await res.json();
    expect(agents.length).toBe(8);
    expect(agents[0]).toHaveProperty('slug');
    expect(agents[0]).toHaveProperty('name');
    expect(agents[0]).toHaveProperty('example_prompts');
  });

  test('GET /sessions returns array', async ({ request }) => {
    const res = await request.get(`${BASE}/sessions`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    expect(res.ok()).toBeTruthy();
  });

  test('POST /app/chat returns SSE stream', async ({ request }) => {
    const res = await request.post(`${BASE.replace('/api', '')}/app/chat`, {
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/x-www-form-urlencoded',
        Accept: 'text/event-stream',
      },
      data: 'msg=Hello',
    });
    expect(res.status()).toBe(200);
  });
});
```

### Running Playwright Tests

```bash
npx playwright test

# Run against a custom backend
API_BASE_URL=http://localhost:5009/api npx playwright test

npx playwright test e2e/api-contract.spec.ts
npx playwright test --headed
npx playwright test --reporter=html
npx playwright show-report
```

### Playwright Config

Create `playwright.config.ts`:

```typescript
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  timeout: 30_000,
  retries: 1,
  use: {
    baseURL: process.env.API_BASE_URL || 'https://kanvas.ai/api',
  },
  reporter: [['html', { open: 'never' }]],
});
```

---

## 3. Flutter Platform Setup

Before building for iOS or Android, generate the platform directories:

```bash
flutter create --org ai.kanvas --project-name kanvas .

flutter create --platforms=android --org ai.kanvas --project-name kanvas .
flutter create --platforms=ios --org ai.kanvas --project-name kanvas .
```

This creates `android/` and `ios/` directories with the bundle ID `ai.kanvas.mobile`.

### Verify Platform Builds

```bash
flutter devices
flutter build apk --debug
flutter build appbundle --release
flutter build ios --release --no-codesign
flutter build ipa --release
```

---

## 4. Google Play — Full Registration & Deployment

### Step 1: Create a Google Play Developer Account

1. Go to [play.google.com/console/signup](https://play.google.com/console/signup)
2. Sign in with the Google account that will own the app
3. Accept the Developer Distribution Agreement
4. Pay the one-time $25 registration fee
5. Complete identity verification (2-7 business days)

### Step 2: Create the App Listing

1. Google Play Console → **Create app**
2. Fill in:
   - **App name**: Kanvas
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free

### Step 3: Complete Store Listing

- **Short description** (80 chars): "AI art advisor for the Baltic and Nordic art market"
- **Full description**: Feature overview, 8 agents, supported languages
- **Screenshots**: At least 2 phone screenshots
- **Feature graphic**: 1024×500 PNG
- **App icon**: 512×512 PNG (32-bit, no alpha)
- **Category**: Lifestyle or Education
- **Contact email**: Required
- **Privacy policy URL**: Required (host at kanvas.ai/privacy)

### Step 4-8: Content Rating, Data Safety, Signing, Build, Review

Same flow as standard Android — see Google Play Console documentation. Build command:

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=https://kanvas.ai/api
```

---

## 5. Apple App Store — Full Registration & Deployment

### App ID & Bundle ID

- Bundle ID: `ai.kanvas.mobile`
- App name: Kanvas
- Category: Lifestyle (primary), Education (secondary)

### Build & Upload

```bash
flutter build ipa --release --dart-define=API_BASE_URL=https://kanvas.ai/api
```

Upload via Xcode → Product → Archive → Distribute App, or via Transporter.

---

## 6. TestFlight (iOS Beta)

```bash
flutter build ipa --release --dart-define=API_BASE_URL=https://kanvas.ai/api
xcrun altool --upload-app --type ios \
  --file build/ios/ipa/kanvas.ipa \
  --apiKey <key_id> --apiIssuer <issuer_id>
```

---

## 7. Google Play Internal & Closed Testing

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=https://kanvas.ai/api
```

Upload to Google Play Console → Testing → Internal testing.

---

## 8. Firebase App Distribution (Android)

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://kanvas.ai/api

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app <firebase-app-id> \
  --groups "testers" \
  --release-notes "Build $(date +%Y%m%d): <description>"
```

---

## 9. CI/CD Pipeline

See `.github/workflows/ci.yml` and `.github/workflows/deploy-android.yml`.

### Required GitHub Secrets

| Secret | Purpose |
|--------|---------|
| `FIREBASE_SERVICE_ACCOUNT` | Service account JSON for Firebase App Distribution |
| `FIREBASE_APP_ID` | Firebase Android app ID |
| `KEYSTORE_BASE64` | Base64-encoded release keystore |
| `KEY_ALIAS` | Keystore key alias |
| `KEY_PASSWORD` | Keystore key password |
| `STORE_PASSWORD` | Keystore store password |

### Versioning (build number bumped per deploy)

The version in `pubspec.yaml` is `versionName+versionCode` (e.g. `1.0.2+2`). The
**versionName** (`1.0.2`) is the human-facing semantic version — bump it by hand in
`pubspec.yaml` when you cut a meaningful release. The **versionCode** is the integer
Android/Play use to order builds; it MUST increase on every build or the store rejects
it and Firebase can't distinguish releases.

CI overrides the versionCode automatically by passing the GitHub Actions run number to
every release build, so each deploy gets a unique, monotonically increasing build:

```bash
flutter build apk       --release --build-number=${{ github.run_number }} --dart-define=API_BASE_URL=https://api.kanvas.ai
flutter build appbundle --release --build-number=${{ github.run_number }} --dart-define=API_BASE_URL=https://api.kanvas.ai
```

This is wired into both `ci.yml` (push to main) and `deploy-android.yml` (manual
dispatch). Result: Firebase releases read e.g. `1.0.2 (47)`, `1.0.2 (48)`, … instead of
every build colliding on the same `1.0.1 (2)`. The `+2` in `pubspec.yaml` is only the
local-build fallback; CI always supplies its own build number.

**To bump before a release:** edit `version:` in `pubspec.yaml` (versionName), commit,
and push — CI handles the build number. No need to touch the versionCode by hand.

---

## 10. Environment Configuration

```bash
# Development (local backend)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5009/api   # Android emulator
flutter run --dart-define=API_BASE_URL=http://localhost:5009/api   # iOS simulator

# Production (default — no flag needed)
flutter run
```

---

## 11. Google Sign-In Credentials Setup

### Google Cloud Console (GCP project: `finespresso`)

- **Web Client ID**: `76656799510-2996ug4uc4743ht74g4hsopn61g71ien.apps.googleusercontent.com`
- **Android Client ID**: `76656799510-99q9f28jc0494atvgmjirppeuk2mfe8l.apps.googleusercontent.com`
  - Package: `ai.kanvas.mobile`
  - SHA-1: from debug/release keystore

### Consent Screen

1. User type: External
2. App name: Kanvas
3. Scopes: `email`, `profile`, `openid`
4. Submit for verification before production (>100 users)

---

## Quick Reference: Release Checklist

### Pre-release

- [ ] All `flutter test` pass (209 tests)
- [ ] `flutter analyze` shows no errors
- [ ] `dart format --set-exit-if-changed lib/ test/` passes
- [ ] Version bumped in `pubspec.yaml`
- [ ] Release notes written

### Android Release

- [ ] `flutter build appbundle --release` succeeds
- [ ] Upload to Google Play Console or Firebase App Distribution
- [ ] Verify install on physical device

### iOS Release

- [ ] `flutter build ipa --release` succeeds
- [ ] Upload via Xcode/Transporter
- [ ] TestFlight internal test
- [ ] Submit for App Store review with demo account
