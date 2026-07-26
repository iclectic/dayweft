# Dayweft: Adaptive Day Planner

A day that adapts with you.

Dayweft is a privacy-first adaptive day planner for iOS and Android. It helps people create realistic plans and review explainable schedule changes when reality shifts.

## Implemented

- Planning documentation for the greenfield Flutter product.
- Flutter monorepo scaffold:
  - `apps/dayweft_mobile`
  - `packages/adaptive_day_engine`
  - `packages/dayweft_design_system`
  - `packages/dayweft_domain`
- Initial Material 3 app shell.
- Initial pure Dart domain and adaptive engine APIs.
- Initial Drift database schema and migration entry point.
- Initial CI workflow for format, analysis, tests, coverage, secret scanning and Android build.

## Planned

Most product functionality remains planned. The current scaffold is Phase 2 foundation work, not a complete planner.

Planned areas include Today Timeline editing, Reweave My Day, Reality Check, Inbox and Brain Dump, Quiet Focus, templates, calendar import, Your Rhythm, optional sync, sharing, biometric lock and app-store release preparation.

## Development

```sh
flutter pub get --directory apps/dayweft_mobile
flutter analyze apps/dayweft_mobile
flutter test apps/dayweft_mobile
dart test packages/adaptive_day_engine
dart test packages/dayweft_domain
flutter test packages/dayweft_design_system
```

No account or cloud configuration is required for local development.
