# Testing

Dayweft targets at least 80% coverage across domain and application layers as implementation grows.

Required test categories:

- Domain unit tests.
- Scheduling-rule tests.
- Property-based scheduling tests.
- Widget tests.
- Golden tests.
- Integration tests.
- Accessibility tests.
- Database migration tests.
- Sync conflict tests.
- Calendar permission tests.
- Notification tests where practical.
- Time-zone and daylight-saving tests.

Phase 2 includes scaffold tests and smoke tests. Later phases must add coverage with each vertical slice.

## Implemented verification

Controller journeys use real Riverpod providers, the repository and SQLite. Task/block widget tests cover edits, cancel/error paths, deletion/undo, drag placement and parsed capture confirmation. Additional workflows cover date navigation, selected template application, stale previews and confirmed single-day import. Custom-template tests cover file reopen, stable block identities, buffers, stale edits/deletion undo, capacity, invalid/corrupt records and successful writes followed by refresh errors. Upgrade tests preserve existing rows through v5, v8, v9, v10 and v11 fixtures. Task/template-editor light/dark goldens check layout with Flutter's test font; they are not production screenshots.

The engine includes 100 seeded schedules checked for pairwise overlap independently of its own validator, task identity conservation and fixed-event stability. This does not replace the remaining deadline/window/split/recurrence/DST test matrix.

CI collects mobile LCOV with `flutter test --coverage`, and package coverage with `dart test --coverage=coverage` plus `dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib`. From the repository root, run:

```sh
dart tool/check_coverage.dart apps/dayweft_mobile/coverage/lcov.info mobile
dart tool/check_coverage.dart packages/adaptive_day_engine/coverage/lcov.info package
dart tool/check_coverage.dart packages/dayweft_domain/coverage/lcov.info package
```

Each group must reach 80%; no eligible lines fails the gate. Mobile scope includes only domain/application directories; generated files and presentation code are excluded. GitHub Actions uploads the three LCOV reports and builds Android debug and unsigned iOS simulator targets.

## Reproducible verification

Use `bash scripts/verify.sh`; set `BUILD_ANDROID_DEBUG=1` to include the Android build. The script enforces the pinned Flutter SDK and package lockfiles, checks generated Drift drift, performs read-only formatting checks, analyses all four packages and runs all tests/coverage gates. See [development](DEVELOPMENT.md).

Date-navigation regressions exercise real Riverpod/SQLite, frozen time, shared Inbox, isolated date history/undo, durable reopen and overnight blocks. Civil month/leap boundaries are tested; this does not establish native IANA timezone/DST or TalkBack verification. The baseline was 59 mobile, 15 domain, 15 engine and 2 design-system tests; later executed counts are recorded in [implementation status](implementation-status.md).

## Native Focus probes on a disposable Android emulator

`integration_test/focus_native_test.dart` asserts that the Android MethodChannel returns a real boot-count token, uses file-backed SQLite and records numeric test evidence. It does not mock the native channel. Run from `apps/dayweft_mobile`:

```sh
flutter test integration_test/focus_native_test.dart -d emulator-5554 --reporter expanded
flutter drive -d emulator-5554 --driver=test_driver/integration_test.dart --target=integration_test/focus_native_test.dart --dart-define=FOCUS_LIFECYCLE_STAGE=seed --keep-app-running
adb -s emulator-5554 shell am force-stop app.dayweft.dayweft_mobile
flutter drive -d emulator-5554 --driver=test_driver/integration_test.dart --target=integration_test/focus_native_test.dart --dart-define=FOCUS_LIFECYCLE_STAGE=recover --keep-app-running
adb -s emulator-5554 reboot
# Wait for boot completion before the next command.
flutter drive -d emulator-5554 --driver=test_driver/integration_test.dart --target=integration_test/focus_native_test.dart --dart-define=FOCUS_LIFECYCLE_STAGE=afterReboot --keep-app-running
```

Use only an emulator created for testing; these commands install the provisional Dayweft package, terminate its process and reboot that device. Substitute its serial explicitly. Never target a user's active planner or personal device. The fixture file is `dayweft_native_focus_verification.sqlite`, separate from the normal planner database. `roundtrip` cleans its temporary directory. `seed` leaves a running fixture, `recover` checks same-boot elapsed time, and `afterReboot` expects `needsReview`, preserves measured time and abandons the fixture after explicit resume. The driver retains application data between stages; `flutter test` removes its test app afterwards and cannot be used for these staged probes.

Optional background/lock exercise between `seed` and `recover`: send `KEYCODE_HOME`, then `KEYCODE_SLEEP`; confirm `mWakefulness=Asleep` using `dumpsys power`, allow measurable elapsed time, wake with `KEYCODE_WAKEUP` and dismiss the disposable emulator's keyguard before force-stop/recovery. This establishes only the probed clock/persistence behaviour. It does not verify notification delivery, the full Focus UI, real hardware battery policies, TalkBack, wall-clock/timezone changes or performance. Executed results belong in [the dated verification record](audit/verification-2026-10-29.md).
