# Release Process

Release readiness is planned for Phase 7.

Android debug and unsigned iOS simulator builds have been verified locally with Flutter 3.47.8 / Dart 3.13.7; Xcode 16.4 built the simulator app. The Flutter-generated iOS integration now targets iOS 15 or later and uses its generated local Swift package alongside the existing CocoaPods workspace. `Podfile.lock` is retained for reproducible application builds. These are development build checks, not signed beta/store releases.

Required before public release:

- App identifiers.
- Icons and splash screen.
- Privacy manifest.
- Permission descriptions.
- Privacy policy and support page.
- Account deletion and data export.
- App Store and Google Play screenshots.
- Localisation-ready metadata.
- TestFlight and Play internal testing.
- Signing documentation.
- Semantic versioning.
- Crash reporting policy.
- Review notes.
- Demonstration data.
