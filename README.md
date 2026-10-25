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
- Local buffer and planning-default storage for preferred breaks, contingency time, transition time and per-block travel/preparation/transition/recovery buffers.
- Skippable local-first onboarding for working patterns, day boundaries, planning style and calendar preferences. Sample data is opt-in, removable and reversible without deleting personal tasks.
- Today Timeline local MVP: create, edit, resize, reorder and delete blocks; create tasks in blocks; move tasks between blocks; complete tasks; revision history; undo for supported local changes.
- Inbox local MVP: quick capture and Brain Dump review dates, preferred/approximate times, duration, priority, energy and category locally. Confirmed fields are persisted; a captured batch can be undone.
- Template preview/application for starter templates without overwriting existing blocks.
- Local JSON export/import through Settings.
- Engine-backed Reality Check observations in Today Timeline.
- Reweave My Day entry point with Running Late, Meeting Overran, Task Took Longer, New Urgent Task, Energy Changed, Need A Break, Missed Part Of Day and Custom Disruption options.
- Deterministic Reweave alternatives: Protect Essentials, Balanced Reweave and Reduce Pressure, with protected IDs, deferrals, trade-offs, confidence and confirmation.
- Confirmed Reweave deferrals and flexible-block moves are recorded as reversible local revisions.
- Settings controls for local break, contingency and transition preferences.
- Your Rhythm local evidence summary with manual actual-time entry, a 12-measurement threshold for overall median estimate/actual comparisons, observed spread, record exclusion/deletion and opt-in energy check-ins. Task completion does not fabricate an actual duration.
- Quiet Focus offline timer with pause/resume, interruption logging, completion and abandon.
- Local availability-share draft records with expiry/revocation metadata. Public links and cryptographic token hashing are not implemented.
- Calendar permission-state scaffold. Device permissions and calendar import are not implemented.
- Store-readiness documentation for metadata, permissions, privacy copy, screenshots and release gates.
- Widget, accessibility smoke, golden, repository and engine tests for the implemented local slices.
- Initial CI workflow for format, analysis, tests, coverage, secret scanning and Android build.

## Planned

Most advanced product functionality remains planned. The current app is a local planning MVP with an initial deterministic adaptive-planning slice, not a complete adaptive planner.

Planned areas include richer permitted-window editing, persisted split fragments, full platform calendar import, notification delivery, optional Supabase sync, public sharing endpoints, biometric lock, screenshot production, signing setup and app-store submission.

The full feature and release requirements are unfinished. See [implementation status](docs/implementation-status.md) for current gaps and validation, and the [Calm Time review pack](docs/calm-time-step-1/README.md) for proposed architecture and decisions. The reference React repository could not be re-audited because its URL returned 404.

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
