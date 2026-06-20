# MTBS Flutter Client

Production-oriented Flutter client for the ExpressJS API in `../MTBS`.

## Run

```powershell
flutter run
flutter pub get
dart run build_runner build
flutter run --dart-define=API_BASE_URL=https://2g0wbc53-3000.asse.devtunnels.ms/api/v1
```

Use `http://localhost:3000/api/v1` for Flutter Web and the host machine IP for a physical device. Production builds must provide an HTTPS URL through `API_BASE_URL`.

## Architecture

The code follows the [Flutter application architecture guide](https://docs.flutter.dev/app-architecture):

- **Views and ViewModels:** pages render immutable state; Riverpod Notifiers/providers own UI logic and commands.
- **Repositories:** repository interfaces are the source of truth exposed to ViewModels. Implementations map transport errors to domain `Failure` values.
- **Services:** API services and `DioClient` are stateless wrappers around REST endpoints.
- **Optional domain layer:** entities and repository contracts remain independent from Flutter widgets.
- **Unidirectional data flow:** UI events flow to ViewModels/repositories; immutable state flows back to Views.
- **Dependency injection:** Riverpod providers construct and override dependencies without a service locator.

Each feature is organized as `presentation/domain/data`. Shared networking, errors, configuration, storage, and reusable widgets live in `core`.

## Authentication

- Access token: memory only (`SessionStore`).
- Refresh token: `flutter_secure_storage` only.
- `AuthInterceptor`: adds the bearer token.
- `RefreshTokenInterceptor`: serializes concurrent 401 refresh requests, rotates both tokens, retries once, and clears the session when refresh fails.
- `ErrorMapper`: prevents raw `DioException` from reaching presentation.

## Navigation

GoRouter provides a nested stateful shell, auth guard, generated typed routes for parameterized pages, and deep-link paths such as:

- `https://mtbs.vn/movie/:movieId`
- `https://mtbs.vn/showtime/:showtimeId/seats`
- `mtbs://movie/:movieId`

Universal/App Links still require the production domain association files.

## Code generation

Do not edit `*.freezed.dart`, `*.g.dart`, or generated GoRouter files.

```powershell
dart run build_runner build
```
