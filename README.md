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
- Drift database schema and migration entry point.
- Local-first onboarding with removable sample data.
- Today Timeline local MVP: create, edit, resize, reorder and delete blocks; create tasks in blocks; move tasks between blocks; complete tasks; revision history; undo for supported local changes.
- Inbox local MVP: quick capture, Brain Dump, basic offline parsing with confirmation and moving inbox tasks into timeline blocks.
- Template preview/application for starter templates without overwriting existing blocks.
- Initial CI workflow for format, analysis, tests, coverage, secret scanning and Android build.

## Planned

Most advanced product functionality remains planned. The current app is a local planning MVP, not a complete adaptive planner.

Planned areas include full Reweave My Day alternatives, complete Adaptive Engine UI integration, advanced Reality Check, estimation calibration, energy-aware planning, Quiet Focus sessions, calendar import, Your Rhythm, optional sync, sharing, biometric lock, export/import and app-store release preparation.

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
