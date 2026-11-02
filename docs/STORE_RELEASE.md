# Store release checklist

## Android

1. Keep `android/key.properties` and `android/keystore/*.jks` **out of git**.
2. Change the upload keystore password before Play Console:
   ```bash
   keytool -keypasswd -keystore android/keystore/vortexsales-upload.jks -alias vortexsales
   keytool -storepasswd -keystore android/keystore/vortexsales-upload.jks
   ```
3. Build:
   ```bash
   flutter build appbundle --release --dart-define=VX_API_BASE=https://vorexsales-pro-7.vercel.app
   ```
4. Release builds block cleartext HTTP (`network_security_config.xml`).

## iOS

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set Team + Bundle ID signing.
3. Archive with the same `VX_API_BASE` dart-define.

## Firebase (optional remote push)

1. `flutterfire configure`
2. Add `firebase_core` + `firebase_messaging` to `pubspec.yaml`
3. In `VxPush.initIfAvailable()`, request permission + `saveToken` + `syncTokenToServer()`
4. Device tokens register at `POST /api/devices` (auth required)

Until Firebase config files exist, local notifications + 15s poll remain active.
Upload keystore password (local only): `android/keystore/UPLOAD_PASSWORD.txt`
