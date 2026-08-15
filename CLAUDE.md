# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Generate mocks and serialization code (required before tests run)
dart run build_runner build --delete-conflicting-outputs

# Run all tests (226 tests)
flutter test

# Run a single test file
flutter test test/unit/models/chat_test.dart

# Run tests in a directory
flutter test test/widget/

# Static analysis (errors only — infos/warnings are non-blocking)
flutter analyze --no-fatal-infos --no-fatal-warnings

# Format code
dart format lib/ test/

# Run the app (default API: https://api.kanvas.ai)
flutter run

# Run with custom API URL
flutter run --dart-define=API_BASE_URL=http://localhost:5012

# Generate app icons (after changing assets/images/app_icon.png)
dart run flutter_launcher_icons
```

## Architecture

Flutter mobile client for the Kanvas.ai art advisory platform. Connects to a standalone FastAPI backend at `api.kanvas.ai` via JWT-authenticated REST + SSE endpoints. No local database — all state comes from the API or in-memory Riverpod providers.

### Backend (Kanvas API)

Standalone FastAPI (Python) service at `https://api.kanvas.ai` with 8 specialist LLM agents for the Estonian/Baltic art market. Key mobile-facing endpoints:

- `POST /auth/login` — email/password login → JWT
- `POST /auth/register` — register → JWT
- `POST /auth/google` — Google ID token → JWT
- `GET /auth/me` — validate Bearer token → user info
- `POST /chat` — SSE streaming chat (JSON: `message`, `session_id`; accepts Bearer token)
- `GET /agents` — list 8 agent specs
- `GET /sessions` — list user's sessions
- `DELETE /sessions/{id}` — delete a session
- `POST /sessions/{id}/share` — generate share URL for a session

### State & Data Flow

**Riverpod 3** is the state management layer. The provider dependency chain is:

```
authProvider (AsyncNotifier) → apiClientProvider (Dio + JWT interceptor) → *ServiceProviders → *ScreenProviders
connectivityProvider (StreamNotifier) → AppScaffold (offline banner)
```

- `authProvider` owns the JWT token lifecycle (login, register, restore from secure storage, logout)
- `apiClientProvider` creates a `Dio` instance that auto-attaches the Bearer token via interceptor and throws `UnauthorizedException` on 401
- Each feature has a service class (thin API wrapper) and a provider that holds UI state
- `chatProvider` is a `Notifier<ChatState>` that manages the SSE streaming state machine
- `connectivityProvider` monitors network via connectivity_plus and drives the offline banner

### Chat SSE Streaming

Chat uses **raw `http` package** (not Dio) because Dio doesn't support streaming POST responses well. The flow:

1. `ChatService.streamChat()` sends a JSON POST to `/chat` on `api.kanvas.ai` with `Accept: text/event-stream` and `Authorization: Bearer <token>`
2. Request body: `{"message": "<message>", "session_id": <sessionId>}` (application/json)
3. Parses the SSE wire format (`event: <name>\ndata: <json>\n\n`) into a sealed `ChatEvent` hierarchy
4. `ChatNotifier` consumes the stream and transitions through: idle → add user message → streaming (accumulate tokens, track tool calls) → finalize assistant message → idle
5. 8 event types: `session`, `agent_route`, `token`, `tool_start`, `tool_end`, `artifact_show`, `done`, `error`

### 8 Art Agents

| Slug | Name | Category |
|------|------|----------|
| `artist_lookup` | Artist Lookup | Research |
| `artist_compare` | Artist Compare | Research |
| `market_analyst` | Market Analyst | Market |
| `auction_tracker` | Auction Tracker | Market |
| `acquisition_advisor` | Acquisition Advisor | Advisory |
| `portfolio_analyst` | Portfolio Analyst | Advisory |
| `valuator` | Valuator | Valuation |
| `provenance_checker` | Provenance Checker | Valuation |

### Routing

**GoRouter** with auth-guarded routes. Public routes (`/`, `/about`, `/contact`, `/shared/:token`) bypass auth. Protected routes use a `ShellRoute` with `AppScaffold` (drawer sidebar + offline banner). Auth redirect is currently disabled for testing — re-enable in `app_router.dart` when auth token flow is finalized.

### i18n

12 languages via Flutter's built-in localization. ARB files in `lib/l10n/`, generated class is `L10n` (configured in `l10n.yaml`). Template is `app_en.arb`. Locale is stored in `localeProvider`.

### Theme

Single `AppTheme.light` in `config/theme.dart`. Uses a dark ink (#1A1A1A) + white palette with gray tones. Available grays: `gray50`, `gray100`, `gray200`, `gray400`, `gray500` (no gray300 or gray600). Material 3, Inter font family.

### Key Patterns

- **Models** are plain Dart classes with `fromJson`/`toJson` (no freezed codegen in use despite the dependency)
- **Services** are stateless API wrappers that take `ApiClient` and return typed models
- **Providers** use Riverpod 3 API: `Notifier`/`NotifierProvider` for mutable state, `FutureProvider` for async reads, `Provider` for derived/computed values. No `StateNotifier` or `StateProvider` (Riverpod 2 API removed).
- **Widget tests** that touch providers watching network-backed `FutureProvider`s (like `agentsProvider`) must override them to avoid pending timer failures
- The `Override` type from Riverpod is **not** exported from the main `flutter_riverpod` barrel in v3; avoid using it as a type annotation

## Testing

25 test files, 226 tests. Three layers:
- `test/unit/` — models (JSON round-trip), services (mocked Dio via `@GenerateMocks`), utils
- `test/widget/` — individual widget rendering and interaction (10 files)
- `test/integration/` — multi-widget flows using providers and router (5 files)

Service tests require generated mock files. Run `dart run build_runner build` before `flutter test` if mocks are missing.

## CI/CD

GitHub Actions CI (`.github/workflows/ci.yml`) runs on every push to main:
1. Analyze (format + static analysis)
2. Test (226 tests with coverage)
3. Build Android APK + AAB
4. Distribute APK to Firebase App Distribution (testers group)

Manual deploy: `.github/workflows/deploy-android.yml` (workflow_dispatch)

## Firebase & GCP

- **Firebase Project**: TBD (pending `kanvas-mobile` project setup)
- **Package**: `ai.kanvas.mobile`
- **Google OAuth** (GCP project `finespresso`):
  - Web Client ID: `76656799510-2996ug4uc4743ht74g4hsopn61g71ien.apps.googleusercontent.com`
  - Android Client ID: `76656799510-99q9f28jc0494atvgmjirppeuk2mfe8l.apps.googleusercontent.com`
