# ReFind

A Flutter/Dart lost-and-found frontend for Android, iOS and web.

## Run

The quickest way to start the local web app is:

```sh
npm run dev
```

Then open http://localhost:8080. The command loads the Web AMap key and
security code from `.env.local` when present. Stop the server with `Ctrl+C`.

The equivalent Flutter commands are:

Install the stable Flutter SDK, then from this directory:

```sh
flutter pub get
flutter run -d chrome
```

For a phone or simulator, use `flutter devices` and `flutter run -d DEVICE_ID`. Android builds require Android SDK tooling; iOS builds require Xcode and signing for physical devices.

## Check

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

## Device integrations

The frontend now contains real integration boundaries for Firebase
authentication, Firestore reports, Storage photos, Firebase Messaging,
camera/gallery access, and location permissions. Firebase remains disabled
until configuration is supplied; no credentials belong in this repository.
Reports support selecting up to six photos from the gallery, with previews and
individual removal before publishing.

Install the FlutterFire CLI and configure a Firebase project:

```sh
dart pub global activate flutterfire_cli
flutterfire configure
```

Alternatively, run with the Firebase values supplied by your secret manager:

```sh
flutter run \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_STORAGE_BUCKET=...
```

Enable Email/Password Authentication, Firestore, Storage, and Cloud
Messaging in the Firebase console. Add Google Maps Android and iOS API keys
to the native Google Maps setup before enabling interactive map tiles.

## AMap location picker

On Android and iOS, the report location step uses AMap. It shows the device's
current location after permission is granted and lets the user tap the map to
choose an exact point. Keep the keys out of Git and provide them at runtime:

```sh
export AMAP_ANDROID_KEY='your-android-key'
export AMAP_IOS_KEY='your-ios-key'
export AMAP_WEB_KEY='your-web-js-key'
export AMAP_WEB_SECURITY_CODE='your-web-security-code'
export FLUTTER_DEVICE='device-id'
flutter run -d <android-or-ios-device> \
  --dart-define=AMAP_ANDROID_KEY="$AMAP_ANDROID_KEY" \
  --dart-define=AMAP_IOS_KEY="$AMAP_IOS_KEY" \
  --dart-define=AMAP_WEB_KEY="$AMAP_WEB_KEY" \
  --dart-define=AMAP_WEB_SECURITY_CODE="$AMAP_WEB_SECURITY_CODE"
```

Or create `.env.local` in the project root:

```env
AMAP_ANDROID_KEY=your-android-key
AMAP_IOS_KEY=your-ios-key
AMAP_WEB_KEY=your-web-js-key
AMAP_WEB_SECURITY_CODE=your-web-security-code
FLUTTER_DEVICE=your-device-id
```

Then run:

```sh
npm run dev:amap
```

`.env.local` is ignored by Git and must never be committed.

The app already requests camera, photo, location, and notification
permissions; the user must grant them on the device. Web loads AMap JS with
the Web JS key, uses browser geolocation for the initial position, and lets
the user tap the map to select coordinates. Native Android and iOS use the
AMap Flutter plugin. If AMap provides a Web security JS code for your key,
set `AMAP_WEB_SECURITY_CODE` as shown above.

## Explore

Start with onboarding or continue as a guest. Create a lost/found report, open it from Reports, and mark it recovered. Search the community feed or filter by lost/found. Explore the manual route and photo matching entry point.

## Scope

This frontend is ready for backend integration. Reports are currently held in local app state. Account forms validate locally but do not authenticate yet. Locations are entered manually, while photo uploads, GPS, notifications, private messaging and image matching are integration points for the backend. No credentials or reports are transmitted.

See [DESIGN.md](DESIGN.md) for screen flows, visual decisions and the production integration plan.

Flutter uses **Dart** for the app. Python is a good optional choice for a later API/image-processing service, not required to run this frontend.

## Validation from this implementation

- Flutter analyzer: no issues.
- Interaction tests cover onboarding, report validation/creation, and search/report navigation.
- Four phone screens rendered and inspected at 390 × 844; see `docs/previews/`.
- Browser compilation was not completed: the first-time Flutter web SDK download was interrupted after slow progress. Android/iOS device builds were not run.

To regenerate the visual previews on macOS:

```sh
flutter test tool/preview_test.dart --update-goldens --dart-define=PREVIEW_FONT=/System/Library/Fonts/Supplemental/Arial.ttf
```
