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
2. Add `firebase_core` + `firebase_messaging`
3. Implement `VxPush.initIfAvailable()` body to request permission and `saveToken`

Until Firebase is wired, local notifications + 15s poll remain active.
