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

Controller journeys use real Riverpod providers, the repository and in-memory SQLite. Task/block widget tests cover edits, cancel/error paths, deletion/undo, drag placement and parsed capture confirmation. Upgrade tests preserve existing rows through v5, v8 and v9 fixtures. Task-editor light/dark goldens check layout with Flutter's test font; they are not production screenshots.

The engine includes 100 seeded schedules checked for pairwise overlap independently of its own validator, task identity conservation and fixed-event stability. This does not replace the remaining deadline/window/split/recurrence/DST test matrix.

CI collects mobile LCOV with `flutter test --coverage`, and package coverage with `dart test --coverage=coverage` plus `dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib`. From the repository root, run:

```sh
dart tool/check_coverage.dart apps/dayweft_mobile/coverage/lcov.info mobile
dart tool/check_coverage.dart packages/adaptive_day_engine/coverage/lcov.info package
dart tool/check_coverage.dart packages/dayweft_domain/coverage/lcov.info package
```

Each group must reach 80%; no eligible lines fails the gate. Mobile scope includes only domain/application directories; generated files and presentation code are excluded. GitHub Actions uploads the three LCOV reports and builds Android debug and unsigned iOS simulator targets.
