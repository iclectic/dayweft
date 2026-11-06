# Dayweft 1.0 engineering tracker

Directive baseline: 26 October 2026, `33b5103`, `feat/dayweft-plan-completion`. Product identity is Dayweft; the Calm Time proposal pack is historical input. No rebuild of the project or implicit cloud activation is authorised.

Status vocabulary: NOT STARTED, IN PROGRESS, VERIFIED, BLOCKED. Evidence distinguishes code review, automated checks, Android device checks and live-backend verification. VERIFIED applies only to the exact scope described.

| Phase | Required result | Status | Next acceptance gate |
| --- | --- | --- | --- |
| 1 Audit | Five baseline audit documents and source-backed gap ledger | IN PROGRESS | Record all baseline command outcomes |
| 2 Foundations | Reproducible SDK/dependencies, environments, clocks/DI/errors/logging, scripts | IN PROGRESS | Full verification script and Android debug build |
| 3 Design | Cohesive M3 identity, themes/motion/responsive/accessibility states | IN PROGRESS | All primary screen goldens/manual review |
| 4 Onboarding | Skippable/resumable complete choices, safe opt-in samples | IN PROGRESS | Draft restart and first-plan journey |
| 5 Timeline/tasks | Dates, current time, complete constraints, no-loss durable revisions | IN PROGRESS | Cross-date persistence/edit/undo and window/allocation tests |
| 6 Capture | Offline reviewed atomic capture, Inbox tools and native entry | IN PROGRESS | External share/dedup/restart/permission tests |
| 7 Templates | Starters/custom editing, selected safe application and recurrence | IN PROGRESS | Manual Android/accessibility and full-backup verification; automatic recurrence is not implemented |
| 8 Engine | All hard constraints and persisted splits, deterministic alternatives | IN PROGRESS | Independent invariants/oracle and temporal test matrix |
| 9 Reweave | Actual disruption effects, before/after and durable decisions | IN PROGRESS | All disruption inputs and no-mutation cancellation |
| 10 Focus | Durable measured countdown/count-up with lifecycle/platform evidence | IN PROGRESS | Native emulator probes pass; full UI, hardware, timezone/clock and notifications pending |
| 11 Rhythm | Eligible real measurements, cohorts/trends/deletion/controls | IN PROGRESS | Focus linkage and reproducible reflection summaries |
| 12 Calendar | Real least-privilege read integration and reconciliation | NOT STARTED | Native adapter + provider device tests |
| 13 Notifications/platform | Optional actual reminders, native capture/back/shortcuts | NOT STARTED | Delivery/cancellation/denied/timezone checks |
| 14 Account/sync | Optional sessions and conflict-safe versioned sync/RLS/deletion | NOT STARTED | Local two-client hostile tests; live access BLOCKED |
| 15 Sharing | Selected secured hosted snapshots and real revocation | NOT STARTED | Endpoint/tenant/rate/expiry tests; host BLOCKED |
| 16 Settings/privacy | Every visible setting functional; full import/export/deletion/lock | IN PROGRESS | Strict previewed import, persisted display choices, complete deletion |
| 17 Security | Threat/data/permission reports + real secret/advisory scans | IN PROGRESS | Executed scan and mitigations, native/backend review |
| 18 Accessibility/locale | en_GB, non-drag, scale/RTL/keyboard and manual AT | IN PROGRESS | Primary journeys on named Android devices |
| 19 Tests | Meaningful 80% domain/application and full regression matrix | IN PROGRESS | Full suite + coverage, native/backend/E2E gaps explicit |
| 20 Performance | Profile release workloads on representative hardware | NOT STARTED | Actual measured traces; no invented budgets/results |
| 21 CI | Reproducible least-privilege validation, scans, builds/artifacts | IN PROGRESS | Real scanner integration and actual Actions run |
| 22 Android production | Final identity/SDK/assets/16 KB/proper signing | IN PROGRESS | Signing/identity owner inputs BLOCKED |
| 23 Store pack | Accurate genuine assets, privacy/support/declarations | NOT STARTED | Working release screenshots and owner-reviewed materials |
| 24 Play workflow | Owner-run test tracks, access and rollout evidence | BLOCKED | Owner account/signing/tester participation/approval |
| 25–28 Release/handover | Full evidence matrix and honest final verification | NOT STARTED | All release acceptance criteria, not just an AAB |

## Execution queue

1. Verify baseline; implement environment/time injection and reproducible verification/release guard scripts.
2. Complete civil-date navigation through repository/controller/timeline; test isolation, history and stale actions.
3. Replace unchecked template application with selected, versioned, non-overlapping duplicate-safe previews; add at least five starters.
4. Strengthen import envelope/row validation and add preview; retain full-backup gaps explicitly.
5. Replace foreground-only focus with durable session state and actual-time linkage, then native integrations.
6. Continue the directive phases and cross-cutting gates without claiming external verification from code alone.

## Baseline checkpoint (26 October)

- Last completed phase: baseline audit documents created; validation results being consolidated.
- Changed files: AGENTS.md, docs/audit/*.md, docs/ROADMAP.md.
- Tests actually run: baseline mobile (59 pass), domain (15 pass), engine (15 pass), mobile analysis and repo formatting pass, code generation pass with analyser warning, Android debug build pass with tooling warnings. Design-system result pending collection.
- Outstanding defects: debug release signing, template conflicts/duplicates, Today-only context, weak import envelope, foreground focus, scaffold sharing/calendar.
- Unfinished requirements: all remaining matrix rows above; no 1.0 completion claimed.
- Human action required: final Android identity, signing credentials, live cloud/host, policy/support URLs, representative device checks and Play Console/testing/approval.
- Exact next implementation task: add injectable clock/environment configuration and verification/release scripts, then date-isolated planning commands and tests.
- Do not modify: existing user history, generated Dart by hand, production accounts/deployments, release keys or other repositories.

## Checkpoint — 27 October 2026

- Last completed slices: audit records, selected-date planning/history, five reconciled starter templates, strict previewed day imports, durable Focus state and Android release guards. These are verified slices, not completed 1.0 phases.
- Changed files: README/CHANGELOG and audit/development/security/release docs; clock/configuration/date selection; repository/controller/import/templates/Focus; domain template logic; schema v11/generated code; migrations/regressions; Android tooling/manifest/native time channel; locks and scripts.
- Tests actually run/results: `bash scripts/verify.sh` passed generation-drift, format, all four analyses and 81 mobile + 19 domain + 15 engine + 2 design tests. Coverage 94.7% mobile domain/application, 88.6% domain, 90.2% engine. Android debug build passed. Missing-key release guard behaved correctly. Gitleaks worktree/history scans and OSV (165 package versions) had no matches.
- Outstanding defects: legacy Kotlin-plugin warning; CI still follows stable and uses its old secret check; calendar/public-share UI remains scaffolded; Android-native lifecycle behaviour has not been device-verified.
- Unfinished requirements: all full-phase acceptance gates above, including custom/recurring templates, full backups, persisted splits/windows, native integrations, cloud/security/privacy controls and production release evidence.
- Human action required: final identity/signing, backend/host ownership, privacy/support publication, named-device tests, actual Play tracks/testers/approval. No publication claim is made.
- Exact next task: widget/integration regression tests for date, template selection and import confirmation, then Android Focus lock/background/kill/reboot exercises and permitted-window/custom-template persistence.
- Evidence: [verification record](audit/verification-2026-10-27.md), [security checks](security/verification-report.md), [manual gates](release/manual-verification.md).

The earlier execution queue records the original sequence. Its first five slices now have implementations and automated evidence; remaining acceptance criteria are still open. Preserve existing user data and forward migrations when resuming.

## Current checkpoint — 29 October 2026

- Last completed slice: Phase 7 custom-template library, plus the preceding date/import/template workflow regressions and native Focus probes. No whole 1.0 phase or release is declared complete.
- Completed: local create/edit/rename/duplicate; reviewed save-from-day; block time/type/category and four-buffer editing; confirmation and version-checked deletion undo; stable block identities; edited/deleted source preview rejection; existing-day protection. Schema v12 adds only `saved_templates`; real-row v11 upgrade and file-reopen tests pass.
- Changed files: template repository/controller/editor/picker, planning template resolution/application, domain template models/validation/reconciliation, database schema/regenerated Drift output, migration/repository/widget/golden tests, native Focus integration test/driver and SDK dev-dependency lock; README/CHANGELOG, audit/data/testing/dependency/security/release records and this ledger.
- Tests actually run/results: `bash scripts/verify.sh` passed locked resolution, generation drift, formatting, all four analyses and 110 mobile + 21 domain + 15 engine + 2 design tests (148 total). Coverage: mobile domain/application 363/375 (96.8%), domain 221/247 (89.5%), engine 403/447 (90.2%). Normal `flutter build apk --debug` passed. Two custom-editor light/dark goldens were generated, rerun and visually inspected; the 320px dark 200% text buffer-edit/validation flow and automated 48px target check pass.
- Android evidence: isolated headless ARM64 Android 36 emulator, real MethodChannel and file-backed SQLite. Roundtrip/pause/reopen, actual force-stop recovery, actual reboot uncertainty and a second background/screen-off/force-stop recovery passed. These are native clock/repository probes, not full Focus UI, real hardware, TalkBack or notification evidence. [Exact commands and observations](audit/verification-2026-10-29.md).
- Security checks: Gitleaks v8.30.1 worktree scan found no leaks; OSV returned no advisory matches for the three newly added public test-only dependency versions. Runtime dependency versions did not change. No remote service, permission or background service was introduced.
- Outstanding defects: legacy Kotlin-plugin build warning; CI still needs pinned SDK/real scanner integration; calendar/public-share controls remain scaffolds. No new known blocking defect in this slice remains after sequential main-thread review and regression fixes.
- Unfinished requirements: recurrence/exceptions and occurrence deduplication; hard task windows, persisted splits, full-device backups (including custom templates), onboarding draft recovery, richer insights/settings/localisation, native notifications/calendar/capture, optional sync/account deletion, hosted sharing, biometrics and release/device/performance/accessibility gates.
- Human action required: final application identity/upload signing, cloud/host ownership and credentials, privacy/support publication and review, named-hardware exercises, actual Play tracks/tester participation/approval. Signing and deployment remain blocked externally.
- Exact next implementation task: persist recurring-template rules and per-date exceptions; preview a selected occurrence with stable occurrence identities, stale guards and atomic application/undo; add civil weekday/overnight/duplicate tests and real-row migration tests before enabling recurrence in the UI. Then continue hard permitted-window modelling and persisted split allocations.
- Do not modify: existing user data, generated Dart manually, provisional identity without owner confirmation, upload keys, production accounts/deployments or unrelated repositories. Keep local-only/offline use working.

## Checkpoint — 6 November 2026

- Last completed slice: CI now reads `.flutter-version`, uses the shared verification script for locked resolution and generation-drift checks, and limits its token to repository read access. The hosted workflow has not yet been run.
- Changed files: `.github/workflows/ci.yml`, `docs/DEVELOPMENT.md`, `docs/audit/release-blockers.md`, this roadmap and `docs/implementation-status.md`.
- Tests actually run: `bash scripts/verify.sh` passed locked resolution, generation drift, formatting, all four analyses and all test suites; coverage was 96.8% mobile domain/application, 89.5% domain and 90.2% engine.
- Outstanding defects: CI's keyword search is not a secret scanner; real scanner/advisory integration, hosted workflow execution and release-bundle verification remain open. The legacy Kotlin warning and calendar/share scaffolds remain.
- Unfinished requirements: recurrence/exceptions, scheduling constraints and persisted splits, native integrations, optional sync and secure sharing, release and manual verification remain as recorded above.
- Human action required: identity, signing, service ownership, policy/support review, hardware testing and Play approval remain outstanding; no credentials or production operation were attempted.
- Exact next implementation task: persist recurring-template rules and per-date exceptions, with stable occurrence identities, explicit preview, version checks and atomic application/undo; cover migration, civil weekdays, overnight occurrences and duplicate prevention before enabling the UI.

## Recurrence foundation — 6 November 2026

- Last completed slice: a pure domain weekly recurrence rule evaluates inclusive civil-date boundaries, ISO weekdays and excluded dates without adding elapsed 24-hour durations. Invalid weekday sets and reversed ranges are rejected; input collections are copied.
- Changed files: `packages/dayweft_domain/lib/dayweft_domain.dart`, `packages/dayweft_domain/lib/src/template_recurrence.dart`, `packages/dayweft_domain/test/template_recurrence_test.dart`, this roadmap and `docs/implementation-status.md`.
- Tests actually run: in `packages/dayweft_domain`, `dart format lib/dayweft_domain.dart lib/src/template_recurrence.dart test/template_recurrence_test.dart`, `dart analyze` and `dart test` passed (25 tests).
- Outstanding defects and unfinished requirements: this model is not persisted or connected to preview/application, and does not constitute a recurring-template feature. Schema migration, exception editing, occurrence identities, stale guards, atomic undo, overnight and full-chain tests remain required, alongside the other open 1.0 gaps above.
- Human action required: existing identity, signing, hosting, device and Play gates remain unchanged.
- Exact next implementation task: persist versioned recurrence rules and exceptions using a non-destructive migration and real-row upgrade test; connect occurrence preview to the existing confirmation and undo path before exposing controls.

## Recurrence storage checkpoint — 6 November 2026

- Last completed slice: schema v13 adds local recurrence storage; versioned rules and excluded civil dates survive reopening. Removal keeps a versioned tombstone, and stale rule or template versions cannot overwrite current state.
- Changed files: database schema and regenerated Drift output, recurrence repository, migration and repository tests, this roadmap and `docs/implementation-status.md`.
- Tests actually run: mobile `dart run build_runner build`, formatting, `flutter analyze`, focused migration/repository tests (10 passed), and `bash scripts/verify.sh` (114 mobile, 25 domain, 15 engine and 2 design tests passed). Coverage gates: mobile domain/application 96.8%, domain 90.2%, engine 90.2%.
- Outstanding defects and unfinished requirements: recurrence is not exposed in the UI or connected to occurrence previews, duplicate protection and durable application/undo. Date exceptions only suppress future reviewed occurrences; no existing day is modified. Full backup, native integrations and other 1.0 gates remain open.
- Human action required: existing identity, release signing, hosting, device and Play gates remain unchanged.
- Exact next implementation task: connect versioned recurrence occurrences to selected-date previews and atomic revision/undo, including rule-change staleness, duplicate and overnight tests, before adding recurrence controls.

## Recurrence occurrence checkpoint — 6 November 2026

- Last completed slice: the planning controller and repository can preview an eligible selected-date occurrence and apply selected blocks atomically through the existing conflict protection and durable revision/undo. Application rechecks rule version, eligibility, template version and plan revision; existing per-day template source identities prevent duplicates.
- Changed files: planning repository/controller, `apps/dayweft_mobile/test/recurring_template_application_test.dart`, this roadmap and `docs/implementation-status.md`.
- Tests actually run: mobile formatting, `flutter analyze`, focused occurrence tests, and `bash scripts/verify.sh` passed (117 mobile, 25 domain, 15 engine and 2 design tests). Coverage gates: mobile domain/application 96.8%, domain 90.2%, engine 90.2%. The real controller/SQLite tests cover excluded days, changed rules/dates, duplicate protection, existing commitments, actual file reopening/undo and an overnight occurrence.
- Outstanding defects and unfinished requirements: recurrence has no user-facing rule or exception controls and is not automatically applied. UI accessibility, visual verification and end-to-end testing are still required. Other 1.0 gaps, including full backups and native/cloud/release work, remain open.
- Human action required: existing identity, upload signing, hosting, device and Play gates remain unchanged.
- Exact next implementation task: expose creation/editing/removal of weekly rules and date exceptions and a selected-day occurrence preview using the existing confirmation dialog; cover stale/error, cancellation, large-text and accessibility paths through the real controller.

## Recurrence controls checkpoint — 6 November 2026

- Last completed slice: custom-template actions expose weekly rule editing, start/end dates, excluded dates, confirmed removal and a selected-day recurrence preview. No rule applies blocks automatically. Selected blocks are applied through the existing version-checked revision/undo path.
- Changed files: template library provider, picker and recurrence editor, template widget tests, this roadmap and `docs/implementation-status.md`.
- Tests actually run: formatting, mobile analysis, focused template widget tests and `bash scripts/verify.sh` passed after correcting a semantics-test cleanup error in the first full run. Final suite: 121 mobile, 25 domain, 15 engine and 2 design tests; coverage gates mobile domain/application 96.9%, domain 90.2%, engine 90.2%. Widget tests cover rule validation, excluded dates, removal confirmation, stale edits, preview cancellation/application/undo, and 320px dark layout at 200% text with automated touch-target checks.
- Outstanding defects and unfinished requirements: no device/TalkBack or visual screenshot verification was performed; single-day export does not back up templates or recurrence. Automatic application is deliberately absent. Full temporal task constraints, persisted splits and all other 1.0 gaps remain open.
- Human action required: existing identity, upload signing, hosting, hardware and Play gates remain unchanged.
- Exact next implementation task: implement hard earliest/latest task windows across domain validation, editor, persistence and scheduling, with migration and real-chain tests; preserve existing tasks and reject infeasible previews.

## Task-window engine foundation — 6 November 2026

- Last completed slice: domain tasks accept optional earliest-start/latest-finish bounds; validation rejects windows too small for the estimate. Reality Check treats a block extending beyond a planned task's bounds as a hard concern. Recovery moves flexible blocks no earlier than their tasks' bounds, rejects infeasible candidates and retains bounds through deferral; application validation rejects altered bounds in a proposal.
- Changed files: domain task models/validation/tests; adaptive engine and constraint tests; timeline observation icon; recovery proposal validation; this roadmap and `docs/implementation-status.md`.
- Tests actually run: package analyses/tests, focused engine regression tests and `bash scripts/verify.sh` passed (121 mobile, 26 domain, 17 engine and 2 design tests; all coverage gates passed). An initial root `dart analyze` reported a missing root lints include and the newly added enum switch case; the switch was fixed, and package analyses passed. The first verification attempt stopped on formatting; the final run passed.
- Outstanding defects and unfinished requirements: these bounds are **not yet stored, editable, imported/exported or mapped from application tasks**, so users cannot use this feature. Conservative whole-block checks can reject feasible arrangements until individual task allocations exist. Persisted splits and the remaining 1.0 requirements are still open.
- Human action required: existing identity, upload signing, hosting, hardware and Play gates remain unchanged.
- Exact next implementation task: add a non-destructive task-window migration, repository mapping, revision/undo and import/export support, then task editor controls and real-chain tests before claiming the feature works.

## Task-window persistence checkpoint — 6 November 2026

- Last completed slice: schema v14 adds nullable earliest-start/latest-finish task bounds, exposed in the task editor and carried through validation, revisions/undo, day import/export and the Reality Check/recovery engine. Existing v13 task rows upgrade without bounds or data loss.
- Changed files: database schema/regenerated Drift output, import validation, planning repository/revision comparison, task editor, migration/repository/controller/widget tests and task-editor goldens, this roadmap and `docs/implementation-status.md`.
- Tests actually run: `dart run build_runner build`, formatting, mobile analysis and focused tests; `flutter test --update-goldens test/task_editor_widget_test.dart` generated light/dark fixtures which were visually inspected; final `bash scripts/verify.sh` passed (125 mobile, 26 domain, 17 engine and 2 design tests). Coverage: mobile domain/application 97.2%, domain 90.3%, engine 91.7%. First full verification stopped on formatting and was rerun successfully.
- Outstanding defects and unfinished requirements: Reality Check reports manual placements outside bounds and recovery rejects invalid candidates; manual placement is not blocked. Whole-block enforcement is conservative until individual allocations exist. Full-device backups, DST/device testing, persisted task splits and remaining 1.0 gates remain open. No device or TalkBack verification is claimed.
- Human action required: existing identity, upload signing, hosting, device and Play gates remain unchanged.
- Exact next implementation task: design and implement persisted task fragment allocations with non-destructive migration, explicit preview and no-loss atomic apply/undo; cover dependency ordering, minimum fragments and migration/restart through real controller/repository tests.

## Fragment validation foundation — 6 November 2026

- Last completed slice: pure Dart allocation model and complete-proposal validator require planned task estimates to be conserved, respect split permission and minimum fragments, check placement/time bounds and deadlines, detect overlaps and capacity, and require predecessors to finish first.
- Changed files: domain allocation model/export and tests, this roadmap and `docs/implementation-status.md`.
- Tests actually run: domain formatting, analysis and focused allocation tests; `bash scripts/verify.sh` passed (125 mobile, 31 domain, 17 engine and 2 design tests; all coverage gates passed).
- Outstanding defects and unfinished requirements: allocations are not stored or connected to the engine, controller, previews, UI, import/export or durable undo; split proposals remain rejected. Reserved buffers have durations but no individual positions, so validation checks their capacity, not exact placement. Full-device backup, native integration and other release gates remain open.
- Human action required: existing identity, upload signing, hosting, hardware and Play gates remain unchanged.
- Exact next implementation task: add non-destructive fragment storage with real-row migration and versioned atomic save/reopen tests, then integrate complete validated allocation proposals into recovery preview/apply/undo before exposing splitting.

## Fragment draft storage checkpoint — 6 November 2026

- Last completed slice: schema v15 adds per-day, versioned allocation-draft storage. The repository atomically validates a complete draft against the current plan and checks both plan and draft versions. Drafts survive reopening and are flagged stale when their plan changes or allocations no longer validate; saving does not change task placement or plan history.
- Changed files: mobile database schema/regenerated Drift output, planning repository, migration and file-backed draft tests, this roadmap and `docs/implementation-status.md`.
- Tests actually run: mobile generation, formatting, analysis and focused migration/draft tests; `bash scripts/verify.sh` passed (127 mobile, 31 domain, 17 engine and 2 design tests; mobile domain/application 97.2%, domain 93.9%, engine 91.7%).
- Outstanding defects and unfinished requirements: this stores drafts only; no actual split allocations, recovery preview/application, undo, export or UI exists. Split suggestions remain rejected. Buffer positioning and remaining 1.0 gates remain open; no device/live-backend verification is claimed.
- Human action required: existing identity, upload signing, hosting, hardware and Play gates remain unchanged.
- Exact next implementation task: integrate a concrete fragment proposal into recovery and add atomic live allocation persistence and durable undo, including stale-plan, partial-write, task deletion, export/import and restart tests before enabling UI.

## Concrete allocation proposal checkpoint — 6 November 2026

- Last completed slice: a deterministic pure-Dart greedy allocator constructs explicit timed fragments, validates complete work conservation and exposes a non-mutating proposal through the planning controller. A real controller/repository test saves a proposal as a versioned draft. Fixed commitments remain protected; dependencies, time bounds, minimum fragments and conservative buffer capacity are checked.
- Changed files: adaptive-engine allocation proposal/export/tests, mobile planning repository/controller and controller test, this roadmap and `docs/implementation-status.md`.
- Tests actually run: formatting and `bash scripts/verify.sh` passed (128 mobile, 31 domain, 23 engine and 2 design tests; mobile domain/application 97.2%, domain 93.9%, engine 92.6%). An earlier verification run showed engine lint notices; these were corrected before the final passing run.
- Outstanding defects and unfinished requirements: the proposal is not connected to Reweave, disruption input, live task allocations, UI, import/export or durable undo. It is a greedy search: no proposal does not prove infeasibility. Buffers are conservatively reserved at block ends because their actual positions are not stored. Split application remains rejected and other 1.0 gates remain open.
- Human action required: existing identity, upload signing, hosting, hardware and Play gates remain unchanged.
- Exact next implementation task: model live fragment allocations throughout task placement, deletion and rendering, with forward migration and import/export; then connect disruption-aware recovery preview and atomic apply/undo, guarded by real-chain no-loss tests before enabling UI.
