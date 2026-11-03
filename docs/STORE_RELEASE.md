# Store release checklist

## Android

1. Keep `android/key.properties` and `android/keystore/*.jks` **out of git**.
2. Upload password (local only): `android/keystore/UPLOAD_PASSWORD.txt`
3. Signed AAB (already built when available):
   `releases/vortexsales-1.0.1+2.aab`
4. Rebuild:
   ```bash
   # English JVM locale avoids Arabic digit dex naming bugs on some Windows hosts
   set JAVA_TOOL_OPTIONS=-Duser.language=en -Duser.country=US
   flutter build appbundle --release --dart-define=VX_API_BASE=https://vorexsales-pro-7.vercel.app
   ```
5. Upload the AAB in Play Console → Production / Internal testing.
6. Release builds block cleartext HTTP (`network_security_config.xml`).

## iOS (requires Mac + Apple Developer)

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set Team + Bundle ID signing (`com.muhanadvortex.vortexsales` or your App ID).
3. Archive with the same `VX_API_BASE` dart-define.
4. Optional export template: `ios/ExportOptions.plist` (replace `REPLACE_TEAM_ID`).

## Firebase (optional remote push)

1. `flutterfire configure`
2. Add `firebase_core` + `firebase_messaging` to `pubspec.yaml`
3. In `VxPush.initIfAvailable()`, request permission + `saveToken` + `syncTokenToServer()`
4. Device tokens register at `POST /api/devices` (auth required)

Until Firebase config files exist, local notifications + 15s poll remain active.
Upload keystore password (local only): `android/keystore/UPLOAD_PASSWORD.txt`
