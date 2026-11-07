# Dayweft: Adaptive Day Planner

A day that adapts with you.

Dayweft is a privacy-first adaptive day planner for iOS and Android. It helps people create realistic plans and review explainable schedule changes when reality shifts.

## Implemented

- Product requirements, architecture decisions and a resumable engineering roadmap for the existing Flutter application.
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
- Civil-date navigation with separate persisted plans/history, shared Inbox and a testable clock.
- Today Timeline local MVP: create, edit, resize, reorder and delete blocks; create tasks in blocks; move tasks between blocks; complete tasks; revision history; undo for supported local changes.
- Shared task editor for Today and Inbox: priorities, categories, notes, deadlines, energy, cognitive load, predecessor tasks and split policy; version-checked edits, reversible deletion/return to Inbox and drag-to-block placement.
- Block category/buffer editing, overnight end times, and before/after details for new task/block edit revisions.
- Inbox local MVP: quick capture and Brain Dump review dates, preferred/approximate times, duration, priority, energy and category locally. Confirmed fields are persisted; a captured batch can be undone.
- Five starter templates with selected-block previews fitted around commitments and working hours; duplicate/stale-preview guards and atomic undo.
- Local custom templates: create/edit/rename, duplicate, save a reviewed day's blocks, and confirm deletion with undo. Stable block identities retain duplicate protection after edits; buffers persist and changed/deleted templates invalidate old previews. Task details and notes are not copied.
- Validated single-day JSON import with preview, original-date preservation, repeat-import protection and batch undo. This is not a complete device backup.
- Engine-backed Reality Check observations in Today Timeline.
- Reweave My Day entry point with Running Late, Meeting Overran, Task Took Longer, New Urgent Task, Energy Changed, Need A Break, Missed Part Of Day and Custom Disruption options.
- Deterministic Reweave alternatives: Protect Essentials, Balanced Reweave and Reduce Pressure, with protected IDs, deferrals, trade-offs, evidence explanations and confirmation.
- Recovery previews validate hard constraints before display and account for entered unavailable time. Unsupported split allocations are not presented as applicable alternatives.
- Confirmed Reweave deferrals and flexible-block moves are recorded as reversible local revisions.
- Settings controls for local break, contingency and transition preferences.
- Your Rhythm local evidence summary with manual actual-time entry, a 12-measurement threshold for overall median estimate/actual comparisons, observed spread, record exclusion/deletion and opt-in energy check-ins. Task completion does not fabricate an actual duration.
- Durable Quiet Focus countdown/count-up sessions with custom duration, pause/resume/restart, interruptions, retained abandoned sessions and optional measured task completion with undo. Android monotonic timing has emulator evidence for database reopen, process death and reboot uncertainty; hardware lifecycle checks and notification delivery remain pending.
- Local availability-share draft records with expiry/revocation metadata. Public links and cryptographic token hashing are not implemented.
- Calendar permission-state scaffold. Device permissions and calendar import are not implemented.
- Store-readiness documentation for metadata, permissions, privacy copy, screenshots and release gates.
- Widget, accessibility smoke, golden, repository and engine tests for the implemented local slices.
- CI workflow for format, analysis, tests, separate 80% domain/application coverage gates, coverage artifacts, the initial secret check, Android debug builds and unsigned iOS simulator builds.

## Planned

Recurring templates, complete device backups and advanced product functionality remain planned. Custom templates are local block patterns, with previews that explain omissions; they do not yet implement recurrence or automatically materialise future days. The current app is a local planning MVP with an initial deterministic adaptive-planning slice, not a complete adaptive planner.

Planned areas include richer permitted-window editing, persisted split fragments, full platform calendar import, notification delivery, optional Supabase sync, public sharing endpoints, biometric lock, screenshot production, signing setup and app-store submission.

The full feature and release requirements are unfinished. See [implementation status](docs/implementation-status.md) for current gaps and validation, the [26 October repository comparison](docs/calm-time-step-1/06-repository-comparison.md) for source-backed findings, and the [Calm Time review pack](docs/calm-time-step-1/README.md) for proposed architecture and decisions. The reference React repository could not be re-audited because its URL returned 404.

## Development

Flutter 3.47.8 is pinned in `.flutter-version`. Run `bash scripts/verify.sh` from the root. See [development](docs/DEVELOPMENT.md), [roadmap](docs/ROADMAP.md) and [current verification](docs/audit/verification-2026-10-29.md). Android release builds require an owner-provided upload key and never fall back to debug signing.

```sh
flutter pub get --directory apps/dayweft_mobile
flutter analyze apps/dayweft_mobile
flutter test apps/dayweft_mobile
dart test packages/adaptive_day_engine
dart test packages/dayweft_domain
flutter test packages/dayweft_design_system
```

No account or cloud configuration is required for local development.
