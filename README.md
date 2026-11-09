# ReFind

A Flutter/Dart lost-and-found frontend for Android, iOS and web.

## Run

The quickest way to start the local web app is:

```sh
npm run dev
```

Then open http://localhost:8080. Stop the server with `Ctrl+C`.

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
to the native Google Maps setup before enabling interactive map tiles. The
app already requests camera, photo, location, and notification permissions;
the user must grant them on the device.

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
