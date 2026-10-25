# Store Readiness

## Application Identifiers

- iOS bundle identifier: pending Apple Developer approval.
- Android application id: pending Play Console approval.
- Public product name: Dayweft: Adaptive Day Planner.

## Privacy Manifest And Permission Copy

Dayweft is local-first. Account, sync, sharing, calendar access, notifications and analytics must remain optional.

Required permission copy before release:

- Calendar: used to import fixed commitments into the Today Timeline. Read-only by default.
- Notifications: used for Quiet Focus and reminders the user enables.
- Biometrics: used only for optional application lock.
- Speech/microphone: used only if voice capture is enabled later.

## Metadata

- Tagline: A day that adapts with you.
- Category: Productivity.
- Monetisation: none. No subscriptions, ads, in-app purchases or donations.
- Review notes: demonstrate local onboarding, Today Timeline, Reality Check, Reweave My Day, Quiet Focus, Your Rhythm, export/import and share-token revocation with sample data.

## Screenshots

Required screenshot set:

- Onboarding local-first explanation.
- Today Timeline with fixed and flexible blocks.
- Reality Check observations.
- Reweave My Day alternatives.
- Quiet Focus session.
- Your Rhythm insufficient-data and evidence states.
- Settings privacy/export/share controls.

## Release Gates

- `flutter analyze`
- `flutter test --coverage`
- package analysis and tests
- Android debug and release builds
- iOS simulator build where Xcode is available
- secret scan
- privacy copy review
- accessibility smoke test
- local data export/import round trip
