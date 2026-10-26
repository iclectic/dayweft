# Calm Time implementation status

Initially checked on 24 October 2026; updated on 26 October 2026. This ledger distinguishes working local behaviours from partial surfaces and missing integrations. The baseline table below records the starting gaps; the completed changes section records subsequent progress. The historical phase summaries are not proof that a requirement is complete. The Step 1 pack's consequential redesign proposals remain provisional; the user authorised continuation on the existing architecture and branch.

## Baseline validation

- Flutter 3.41.1 / Dart 3.11.0 installed; latest stable compatibility review still required.
- Existing mobile tests: 18 pass. Engine tests: 7 pass.
- Coverage percentage, real-device accessibility, platform integration and release readiness are not yet established.
- Reference React repository returns 404; source audit remains unverified.

| Required slice | Source-backed baseline | Unfinished acceptance criteria |
| --- | --- | --- |
| Onboarding | Local explanation, finish/skip sample, sample insertion | Working pattern, wake/wind-down, calendar/style choices, per-step skip; sample removal currently risks personal work and misses inbox samples |
| Timeline/tasks | Local CRUD, visual reorder, block-to-block task moves | Full task constraint editing, drag tasks, positive-duration validation, date navigation, original/revised comparison, durable complete undo/history, atomic versioned writes |
| Inbox/brain dump | Text capture and simple parser preview | Parsed fields currently lost on save; date/category/energy parsing, editable confirmation, voice and native share capture |
| Templates | Three hard-coded templates and additive application | Five required starters, custom persistence, actual conflict reconciliation, recurrence/exceptions and duplicate protection |
| Focus | Foreground widget countdown, completion record | Count-up, task/subtasks, durable pause/resume/restart, actual elapsed-time tracking, abandon records, notifications/haptics/platform surfaces |
| Calendar | A permission-state database record | Actual permission requests/revocation, EventKit/provider import, sources/recurrence/DST, write approval |
| Reality Check | Several observations in pure Dart | All-pair overlaps, correct capacity accounting, invalid input, hard/soft separation and constraint interactions |
| Disruption recovery | Three previews, moves/deferrals and local apply/undo | Disruption amounts affect scheduling; all valid constraints, persisted split allocations, stale preview protection, decision learning, validated alternatives, undo history |
| Calibration | Estimate records and simple mean after three records | Existing completion fabricates actual=estimate; genuine actual entry/focus linkage, sufficient cohorts, uncertainty, exclusions and deletion |
| Energy | Check-ins and history deletion | Explicit enable/disable, task attributes, solver influence with explanations, complete controls |
| Insights | Local counts and sample warning | Trends, plan/reality, disruption/interruptions/recovery, acceptance denominators, weekly reflection and full export |
| Optional auth/sync | Dependency declarations and unused queue table | Authentication, secure tokens, atomic outbox, retry/idempotency, conflict handling/UI, RLS and account deletion |
| Sharing | Local token record and availability payload | Token is not actually hashed; no hosted link, selected blocks/templates, endpoint expiry/revocation/rate limits or read-only viewer |
| Settings/privacy | Buffer preferences, partial JSON import/export | Biometrics, notifications/calendars, actual consent controls, theme/time/text/motion, full data export/deletion, privacy/licence surfaces |
| Design/accessibility | Material 3 light/dark, basic semantics and one golden | Token completeness/contrast, large text/RTL/localisation, switch/keyboard journeys and screen-reader verification |
| Foundations/CI | App/packages, Drift v5, initial Actions checks | Freezed/JSON model adoption, typed failures, environments, upgrade migration fixtures, 80% domain/application enforcement, iOS build, real secret scan, templates/dependabot/release process |
| Store readiness | Documentation and generated default assets | Owned identifiers/URLs, branded assets/screenshots, manifests/disclosures, signed beta setup, crash reporting, reviewer journey and store validation |

## Completed changes in this PR

- Persisted working pattern, wake/wind-down, working hours, planning style and calendar preference; each setup step can be skipped and choices remain editable in Settings. Onboarding has its own Navigator for dropdowns and pickers and requests no permissions.
- Samples default to off. Removing samples preserves personal task identity/status/placement for undo, including Inbox samples; installation and removal are idempotent.
- Offline capture recognises dates, approximate/preferred times, duration, priority, energy and category. Both single capture and brain dump display interpretations before saving. Structured fields persist and a batch is one reversible transaction. Voice/share-sheet capture remains missing.
- Positive-duration/task-input validation and missing-destination checks protect local writes. Revision preconditions reject stale commands; undo actions retain original history. Block-delete undo restores task placement/status. Full edit/revision coverage remains unfinished.
- Recovery application rejects stale previews, fixed-event changes, unresolved hard observations and unallocated splits. This guard is not a complete solver implementation; persisted splits and all scheduling constraints remain unfinished.
- Manual actual-duration entry never substitutes the estimate as a measurement. Overall median comparisons require 12 eligible measured records and show empirical middle-half spread, not a probability. Category/context modelling is available in pure Dart; richer cohort UI and focus linkage remain missing.
- Measurements have provenance; legacy records of unknown origin are excluded from calibration. Individual records can be excluded or deleted. Energy collection defaults to disabled, can be disabled again and is hidden from current summaries when disabled. Deleting learning history removes stored learning rows. Energy-aware scheduling remains missing.
- Database schema is now v10, with v5 preference/legacy-evidence, v8 capture-field and v9 task-detail upgrade tests. Cognitive load and predecessor IDs are stored locally; old rows receive nullable/empty defaults.
- Today and Inbox share task editing, deletion, return-to-Inbox, explicit move menus and drag-to-block placement. Edits include estimate, priority, category, notes, deadline, energy/load and split policy. Dependency validation rejects missing/self/duplicate/cyclic links. Deleting an active predecessor is blocked.
- Task and block writes increment local versions. Editors reject stale versions, and new edit revisions retain before/after values. Undo restores attributes and placement; deletion snackbar undo names its revision and cannot undo a later unrelated change. Supported history remains after repository recreation.
- Block editing exposes category and internal travel/preparation/transition/recovery buffers, with explicit next-day end times. Timeline capture uses the same parsed-value confirmation as Inbox. Unscheduled/deferred work remains visible. Local import preserves task constraints and remaps dependency identities.
- Reality Check now checks all overlapping pairs, aggregate sequential task demand, invalid identities/references/durations/buffers and flexible work outside working hours. Utilisation uses clipped union occupancy and does not double-count internal buffers.
- Recovery accounts for entered unavailable minutes, checks resulting candidates before returning them, and returns no applicable option for unresolved fixed conflicts or unsupported splits. Application cross-checks preview identities, stored estimates/dependencies and change-list times. Explanations describe user-estimate evidence rather than confidence percentages. Solving runs in a worker isolate.

## Validation and release limits

- Current SDK: Flutter 3.47.8 stable / Dart 3.13.7.
- Mobile: 59 tests pass, including controller-to-SQLite journeys, task/block editing, gesture placement, confirmation/cancellation, revision comparisons, stale proposals, migration and large-text checks. Shared domain: 15 tests pass. Adaptive engine: 15 tests pass, including independent pair checks across 100 seeded cases and the earlier 25-case invariant fixture. Design-system baseline: 2 tests pass.
- Measured shared-domain line coverage: 144/171 (84.2%); engine: 405/449 (90.2%). Mobile domain/application coverage is 100% in the latest LCOV. CI now enforces a separate 80% gate for each group; generated and presentation code are excluded. Coverage does not establish completion of missing features.
- Android debug APK and unsigned iOS simulator builds succeed. Flutter upgraded iOS integration to an iOS 15 minimum with a generated Swift package; the remaining CocoaPods integration builds successfully. Android still warns about Gradle 8.14.0, AGP 8.11.1 and Kotlin 2.2.20 approaching unsupported status; compatible upgrades remain pending. No signing, store submission or real-device accessibility/performance validation is claimed.
- New task-editor light/dark goldens were inspected as layout regressions; they use Flutter's test font and are not store screenshots. No browser or real-device UI verification is claimed. The CI workflow changes have been checked locally but have not yet run on GitHub.
- Supabase, public sharing, native calendar import, background focus surfaces and other baseline gaps remain unfinished. This is a draft implementation PR, not a production-ready release.
- Timeline date navigation, permitted-window editing, a whole-day original-plan baseline, complete cross-day history, native capture, real routine reconciliation and durable focus still need implementation. The recovery algorithm remains a conservative reflow with validation, not the complete bounded-search solver or a proof of infeasibility; energy/new-urgent-work input, persisted split allocations and decision learning remain unfinished.

## Remaining execution order

Continue in the supplied vertical-slice order, hardening existing local behaviour rather than re-scaffolding. Each slice requires persistence, meaningful tests, offline/error/accessibility states and documentation. No work is complete merely because a route, table, dependency or document exists.

Unconfigured Supabase resources, verified public domain, developer accounts/signing and reference-source access are external inputs. Implement and validate everything independent of those inputs; record exact remaining deployment/device gates instead of claiming production readiness.
