# Kanvas Mobile

Flutter mobile app for [Kanvas.ai](https://kanvas.ai) — an AI art advisory platform for the Estonian and Baltic art market. Research artists, track auctions, and value artworks using 8 specialist AI agents.

## Features

- **AI Chat** — Conversational interface with 8 specialist agents (artist lookup, artist compare, market analyst, auction tracker, acquisition advisor, portfolio analyst, valuator, provenance checker) via real-time SSE streaming
- **12 Languages** — English, Estonian, German, French, Swedish, Latvian, Norwegian, Danish, Polish, Dutch, Finnish, Lithuanian
- **Auth** — Email/password + Google Sign-In with JWT
- **Profile** — Art preferences (mediums, periods, auction houses, markets)
- **Sessions** — Chat history with share links
- **Offline Detection** — Banner shown when network connectivity drops

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.44+ / Dart 3.12+ |
| State management | Riverpod 3 |
| Routing | GoRouter 17 |
| HTTP | Dio (REST) + http (SSE streaming) |
| Auth | JWT Bearer + Google Sign-In v7 |
| i18n | Flutter Localizations (ARB) |
| Storage | flutter_secure_storage + shared_preferences |
| Testing | flutter_test + mockito |
| CI/CD | GitHub Actions + Firebase App Distribution |

## Project Structure

```
lib/
  main.dart                  # Entry point
  app.dart                   # MaterialApp.router + ProviderScope

  config/
    api_config.dart          # Base URL, timeouts (configurable via --dart-define)
    theme.dart               # Material 3 theme (colors, typography)
    constants.dart           # Art mediums, periods, auction houses, countries

  models/                    # Data classes
    auth.dart, chat.dart, session.dart, profile.dart, agent.dart

  services/                  # API layer
    api_client.dart          # Dio client + JWT interceptor
    chat_service.dart        # SSE streaming via POST
    auth_service.dart, profile_service.dart, session_service.dart,
    agent_service.dart, contact_service.dart

  providers/                 # Riverpod state
    auth_provider.dart       # AsyncNotifier for auth state
    chat_provider.dart       # Manages SSE stream, messages, artifacts
    connectivity_provider.dart # Network status monitoring
    locale_provider.dart, session_provider.dart,
    profile_provider.dart, agent_provider.dart

  router/
    app_router.dart          # GoRouter with auth redirect

  screens/                   # Screen modules (chat, auth, profile, about, contact, home)
  utils/                     # Formatters, validators, secure storage
  l10n/                      # 12 ARB files + generated localizations
```

## Setup

### Prerequisites

- Flutter SDK >= 3.44.0
- Dart SDK >= 3.12.0
- Android Studio / Xcode for emulators

### Install & Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Configure API URL

Default API: `https://kanvas.ai/api`

Override at build time:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:5009/api
```

### Google Sign-In

Google OAuth is configured via `--dart-define`:

```bash
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

Default Web Client ID (from GCP project `finespresso`): `76656799510-2996ug4uc4743ht74g4hsopn61g71ien.apps.googleusercontent.com`

Android OAuth Client ID: `76656799510-99q9f28jc0494atvgmjirppeuk2mfe8l.apps.googleusercontent.com` (validated via SHA-1 + package name)

### Run Tests

```bash
# Generate mocks first
dart run build_runner build --delete-conflicting-outputs

# Run all tests (209 tests)
flutter test

# Run by category
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

## Test Suite

23 test files, 209 tests across three layers:

| Category | Files | Coverage |
|----------|-------|----------|
| Unit — Models | 5 | JSON round-trip, computed properties, null handling |
| Unit — Services | 3 | Auth (mocked Dio), SSE parser (all 8 event types) |
| Unit — Utils | 2 | Price formatting, email/password validation |
| Widget | 10 | Login, chat bubbles, input bar, tool cards, welcome, profile, about, contact, home |
| Integration | 5 | Auth flow, chat streaming, navigation, app launch |

## CI/CD

### GitHub Actions (`ci.yml`)

On every push to `main`:
1. **Analyze** — `dart format --set-exit-if-changed` + `flutter analyze`
2. **Test** — `flutter test --coverage` (209 tests)
3. **Build** — `flutter build apk --release` + `flutter build appbundle --release`
4. **Distribute** — APK uploaded to Firebase App Distribution (testers group)

### Firebase App Distribution

- **Firebase Project**: TBD (pending `kanvas-mobile` project setup)
- **Package**: `ai.kanvas.mobile`
- **Testers group**: `testers`

To install on device:
1. Install **Firebase App Tester** from Google Play Store
2. Sign in with your Google account (must be in testers group)
3. Download the latest build

### GitHub Secrets Required

| Secret | Purpose |
|--------|---------|
| `FIREBASE_SERVICE_ACCOUNT` | Service account JSON for Firebase App Distribution uploads |
| `FIREBASE_APP_ID` | Firebase Android app ID |
| `KEYSTORE_BASE64` | Base64-encoded release keystore (optional, uses debug signing if absent) |
| `KEY_ALIAS` | Keystore key alias |
| `KEY_PASSWORD` | Keystore key password |
| `STORE_PASSWORD` | Keystore store password |

## GCP / Firebase Configuration

### GCP Projects

| Project | ID | Purpose |
|---------|-----|---------|
| Kanvas Mobile | TBD | Firebase, App Distribution |
| Finespresso | `finespresso` | Google OAuth client IDs (shared with web app) |

### Google OAuth Setup

- **Web Client ID** (used as `serverClientId` in Flutter): `76656799510-2996ug4uc4743ht74g4hsopn61g71ien.apps.googleusercontent.com`
- **Android Client ID**: `76656799510-99q9f28jc0494atvgmjirppeuk2mfe8l.apps.googleusercontent.com`
  - Package: `ai.kanvas.mobile`
  - SHA-1 (debug): from `~/.android/debug.keystore`

## Backend API

The app connects to the Kanvas FastHTML backend. Key endpoints:

- **Auth** — `POST /api/auth/token`, `/api/auth/register`, `/api/auth/google`, `GET /api/auth/me`
- **Chat** — `POST /app/chat` (SSE streaming, form-encoded: `msg`, `sid`)
- **Agents** — `GET /api/agents`
- **Sessions** — `GET /api/sessions`, `DELETE /api/sessions/{id}`
- **Share** — `POST /api/chat/share`
- **Profile** — `POST /api/user-profile`

## Supported Languages

`en` `et` `de` `fr` `sv` `lv` `no` `da` `pl` `nl` `fi` `lt`

~55 translation keys per language.

## License

Proprietary. All rights reserved.
