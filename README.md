# VortexSales (Flutter)

Phone client for [AMREKA2](https://vorexsales-pro-7.vercel.app). No AI secrets in this app — only the public API origin.

## Run

```bash
flutter pub get
flutter run --dart-define=VX_API_BASE=https://vorexsales-pro-7.vercel.app
```

Local web server:

```bash
flutter run --dart-define=VX_API_BASE=http://127.0.0.1:3002
```

Or set **Settings → Server** inside the app. Default without a define is production.

## Release Android

1. Copy `android/key.properties.example` → `android/key.properties`
2. Create `android/keystore/vortexsales-upload.jks` (never commit it)
3. `flutter build apk --release --dart-define=VX_API_BASE=https://vorexsales-pro-7.vercel.app`

Cleartext HTTP is blocked in release; debug may still hit localhost.

## Checks

```bash
flutter test
flutter analyze
```

Store upload steps: [docs/STORE_RELEASE.md](docs/STORE_RELEASE.md).
