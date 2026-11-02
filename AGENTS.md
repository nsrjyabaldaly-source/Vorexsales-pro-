# VortexSales

Flutter mobile app (Dart SDK `^3.11.5`). The shell is a phone UI: language gate, short how-to, then login.

## Cursor Cloud specific instructions

- The base image does not include Flutter. Install stable Linux Flutter 3.47 or newer (this repo resolved on Flutter 3.47.9 / Dart 3.13.7) and put `flutter/bin` on `PATH`.
- Install packages with `flutter pub get` from the repo root.
- `flutter test` is the check that exercises boot, brand identity, and the button actions (channel connect, settings → channels, coach-mark taps).
- Run the UI with `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080`.
- First screen is language. Continue, skip the how-to, then **Enter demo workspace** to reach the app. While the coach marks are up, the highlighted control can be tapped; **Next mark** / **Skip marks** still advance the tour.
- Channel buttons labeled “Show where it will connect” open an explanation. They do not attach WhatsApp, Instagram, or any live account.
