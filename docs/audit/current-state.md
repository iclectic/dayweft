# Current-state audit

Audit baseline: 26 October 2026, `33b5103`, branch `feat/dayweft-plan-completion`. The working tree was clean. The active repository is `iclectic/dayweft`; no VeriMundi changes were made.

## Implementation inspected

The four existing packages are retained: Flutter application, pure Dart domain, pure Dart scheduling engine and Material 3 design system. Reviewed the README, requirements, historical implementation plan/status, architecture/data model/engine/privacy/testing/store documents, Calm Time proposal pack, package manifests, routes/screens, Drift schema/migrations, repository/controller, tests, workflows and Android/iOS configuration. Proposal documents are historical design input; the present directive establishes Dayweft as the product identity. No inaccessible reference repository is needed to continue this implementation.

Drift schema v10 stores local plans, blocks, tasks, revisions/undo markers, preferences, measurements, energy and focus records. Sync operations, calendar connections and share records exist but do not implement remote/native capabilities. `local_planning_repository.dart` is 2,456 lines and combines persistence, capture, templates, import, learning and engine mapping. The timeline screen combines rendering and several workflows. Decompose responsibility by responsibility with regression protection, rather than replacing the architecture.

The existing application supports skippable onboarding, opt-in samples, local task/block CRUD, capture confirmation, dependencies, measured actual-time entry, stale editor/proposal rejection and supported revision undo. Reweave is a conservative validated reflow, not a complete constraint solver. Its split policy rejects unsupported allocations. It runs off the UI isolate.

## Baseline commands actually run

| Command (relative to relevant package) | Result |
| --- | --- |
| `flutter --version` | 3.47.8 stable, Dart 3.13.7 |
| `java -version` | Temurin JDK 21.0.10; Android source/target level 17 |
| `flutter pub get` (mobile) | Passed with locked dependencies; newer releases reported |
| `dart run build_runner build --delete-conflicting-outputs` (mobile) | Passed, no tracked generated drift; flag is obsolete, analyser 10 supports an older language version |
| `dart format --output=none --set-exit-if-changed .` | Passed: 50 files, no changes |
| `flutter analyze` (mobile) | Passed, no issues |
| `flutter test --coverage --reporter expanded` (mobile) | 59 passed |
| `dart test` (domain) | 15 passed |
| `dart test` (engine) | 15 passed |
| `flutter test --reporter expanded` (design system) | 2 passed |
| `flutter build apk --debug` (mobile) | Passed; Gradle 8.14, AGP 8.11.1 and Kotlin 2.2.20 support warnings |

Flutter commands initially failed in the sandbox because the installed SDK needs cache writes outside the repository. Authorised SDK access resolved that environment restriction; it was not an application defect.

Historical coverage and iOS results have not been adopted as new evidence. No device accessibility, timer lifecycle, release performance, signed release, hosted sharing, multi-device sync or Play Console result is claimed.

## Highest-priority findings

1. Release uses the debug signing configuration; app label and identity are provisional.
2. Today-only persistence commands prevent coherent date navigation. Time and identity dependencies need explicit injection.
3. Templates insert unchecked absolute times, allow repeats and lack safe selection/reconciliation.
4. Import ignores product/schema headers and silently drops malformed list entries; it is a single-day merge, not a complete backup.
5. Quiet Focus increments widget state each second and loses an active session on process termination; abandoned sessions are discarded.
6. Calendar and sharing controls expose scaffold operations as if they were useful integrations.
7. Supabase auth/sync, RLS, account deletion and hosted sharing are absent.
8. No real secret scanner, pinned SDK, generation-drift gate, release signing guard or complete verification script exists.

The [feature matrix](feature-gap-matrix.md), [roadmap](../ROADMAP.md) and [release blockers](release-blockers.md) define the continuation. This audit is the baseline, not a claim that its findings are already fixed.
