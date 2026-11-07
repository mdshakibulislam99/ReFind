# ReFind

A Flutter/Dart lost-and-found UI prototype, based on the supplied ReFind screen reference. Includes Android, iOS and web project targets.

## Run

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

## Explore

Start with onboarding or use Log in → Explore the demo without an account. Create a lost/found report, open it from Reports, and mark it recovered. Search the home feed or filter by lost/found. Explore the manual route and sample matching previews.

## Scope

This is an interactive UI foundation, not a production lost-and-found service. Reports live only in memory. Account screens validate locally; they do not authenticate. Maps are illustrations. Photo uploads, GPS, notifications, private messaging and AI matching need live integrations. No credentials or reports are transmitted.

See [DESIGN.md](DESIGN.md) for screen flows, visual decisions and the production integration plan.

Flutter uses **Dart** for the app. Python is a good optional choice for a later API/image-processing service, not required to run this frontend.

## Validation from this implementation

- Flutter analyzer: no issues.
- Three interaction tests passed: onboarding, report validation/creation, and search/report navigation.
- Four phone screens rendered and inspected at 390 × 844; see `docs/previews/`.
- Browser compilation was not completed: the first-time Flutter web SDK download was interrupted after slow progress. Android/iOS device builds were not run.
- Flutter SDK used in this session: `/private/tmp/refind-flutter-sdk` (temporary installation; install Flutter permanently for continued development).

To regenerate the visual previews on macOS:

```sh
flutter test tool/preview_test.dart --update-goldens --dart-define=PREVIEW_FONT=/System/Library/Fonts/Supplemental/Arial.ttf
```
