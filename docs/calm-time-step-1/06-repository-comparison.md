# Current repository compared with the Calm Time brief

Checked: 26 October 2026. Baseline: `024e27a515a5aa16bbcc9927180624e82b009c40`, branch `feat/dayweft-plan-completion`, remote `iclectic/dayweft`.

This is a source-backed continuation audit. It supplements the five decision documents in this pack; it does not approve their proposed architecture. No production code, dependency declarations, database schema or native configuration was changed for this audit.

## Assessment

The checkout is already a Flutter local-planning MVP. Re-scaffolding would discard useful work. Continue through the supplied vertical slices, checking actual acceptance criteria before treating a slice as complete. Existing plans' historical “Current status” paragraphs are not evidence that a feature works.

The strongest existing behaviours are skippable, persisted onboarding; opt-in samples with preservation tests; local task/block operations with revision records; offline parsed capture with confirmation; manual duration evidence with exclusion/deletion; and stale-preview/fixed-block guards around recovery application.

The largest product risk is that recovery previews look more capable than the solver is. Several hard constraints are not represented or enforced, disruption amounts do not alter scheduling, and split recommendations are not allocations. Passing the current seven engine tests is insufficient to call this a constraint solver meeting the brief.

The requested React reference, `iclectic/calm-time`, again returned HTTP 404 through the connected GitHub repository-metadata API on 26 October. No current reference commit or source was obtained. The [retention matrix](01-reference-audit.md#feature-retention-matrix) remains based on the brief and the explicitly qualified historical report. The reason for the 404 is unknown.

## Feature comparison

“Partial” means useful behaviour exists but the slice's acceptance criteria are not all met. A table, dependency or settings label alone is a scaffold.

| Brief requirement | Current evidence | Remaining acceptance criteria |
| --- | --- | --- |
| 1. Onboarding | **Implemented local core.** `onboarding_screen.dart`, `onboarding_preferences.dart` and repository tests cover persisted working pattern, day boundaries, planning style/calendar preference, per-step skip and opt-in/removable samples. | Verify full journeys on VoiceOver/TalkBack and devices; broader localisation. No launch permission prompts are present. |
| 2. Timeline/tasks | **Partial.** `today_timeline_screen.dart` and `LocalPlanningRepository` provide local CRUD, reorder, movement between blocks, completion, positive-duration guards, revision history and supported undo. | Task editing for notes/deadlines/priority/energy/load/dependencies/windows; task drag; complete revision coverage; date/shift navigation; current-time indicator; original/revised comparison; atomic versioning for every write. |
| 3. Inbox/brain dump | **Partial.** `capture_parser.dart`, `capture_sheet.dart` and persistence tests cover date/time/duration/priority/energy/category parsing, confirmation and batch undo offline. | Voice with capability-aware fallback; native share capture; richer editable review and durable drafts. |
| 4. Adaptive engine | **Partial.** Separate pure Dart package; three named previews; moves, deferral/split candidates; explanations; application rejects stale revisions, moved fixed blocks and some unresolved constraints. | Full hard-constraint model/validation, permitted windows, aggregate task capacity, real split allocation/conservation, disruption-sensitive solving, independent per-alternative feasibility, explainable evidence strength, persisted decisions/learning and comprehensive invariants. |
| 5. Reality Check | **Partial.** Observations exist for overlaps, utilisation, transitions, breaks, deadlines/dependencies, demanding clusters and contingency. | All-pair overlap detection; union/clipped capacity accounting; aggregate work demand; explicit protected-break policy; hard/soft separation; correction choices; validation of identity, references, buffers and windows. |
| 6. My day changed | **Partial.** Today exposes the required disruption families plus “Task took longer”; previews require confirmation. | Collect actual delay/new work/affected event/energy/break inputs and use them as constraints. The current repository passes only a disruption type and timestamp to the engine. |
| 7. Estimation calibration | **Partial.** Genuine manual measurements, provenance, 12-record overall median threshold, empirical spread, exclusions/deletion; pure Dart cohort calculations. Completion does not invent actual duration. | Focus-linked measurements, contextual cohort UI and richer time/day/interruption/split insights; preserve estimate-at-start and avoid duplicate evidence. |
| 8. Energy | **Partial.** Disabled by default; explicit enable/disable; local check-ins and history deletion. | Optional task attributes/editing; actual opt-in solver influence and per-change explanation; disabled-output invariance tests. |
| 9. Focus | **Partial.** Countdown UI, pause/resume, interruption counter and completed-session insertion work in the foreground. | Durable active sessions, count-up, real task/subtask association, timestamp-based elapsed time, stored abandon/interruption history, notifications/haptics, Android foreground notification, Live Activities/widgets and optional audio. |
| 10. Templates/routines | **Partial.** Three constant templates; preview lists blocks; application adds blocks and can undo them. | All eight starters, stored custom routines, actual reconciliation around commitments, duplicate prevention, recurrence/exceptions and stale-preview guards. Existing application inserts original template times even if occupied. |
| 11. Calendar | **Scaffold.** `CalendarConnections` and a Settings reset action record a string; no native permission/import adapter exists. | EventKit/Android provider reads, per-calendar visibility/source identity, recurrence/exceptions, revoked access, conflict handling and IANA/DST intent; separately approved writes and later OAuth ports. |
| 12. Insights | **Partial.** `loadRhythmSummary` exposes local measurement/focus/deferral counts and sample warnings. | Trends, baseline/reality, disruption/interruptions, protected recovery, acceptance denominators, weekly reflection and all-history export. Current export contains today's plan/tasks/preferences, not all data. |
| 13. Sharing | **Scaffold.** Local availability draft, expiry and revocation fields; no hosted viewer or endpoint. | Selected snapshots/templates, proper token digests, HTTPS validation, server-enforced expiry/revocation, RLS and endpoint abuse limits. Removing UUID hyphens is not cryptographic hashing. |
| 14. Settings/privacy | **Partial.** Local planning choices/buffers, JSON import/export, energy/learning controls and draft sharing controls. | Optional secure auth/sync, biometric guard, notifications/calendar controls, consent/AI controls, complete export/cloud deletion, appearance/time/text/motion controls and policy/licence screens. |

### Foundations and release comparison

| Area | Present | Missing or unverified |
| --- | --- | --- |
| Architecture | Riverpod, go_router, Drift v9; separate Flutter design-system and pure Dart domain/engine packages. | Many behaviours remain in the large planning repository; focus business logic lives in its widget. Freezed/json_serializable dependencies do not establish immutable model adoption. Typed failures are only partially consistent. |
| Persistence/sync | Stable UUIDs, migration entry point, local-version/deletion fields and an unused operation table. | A transactional outbox is not wired to all writes; no remote client, retry loop, deterministic conflict handling, cursor/tombstone protocol, RLS fixtures or account deletion. |
| Design/accessibility | Original warm/teal Material 3 light/dark themes; onboarding golden, semantics and large-text smoke tests. | Full token specification, contrast evidence, screen/theme/large-text golden matrix, localisation/RTL/time-format handling, keyboard/switch and device assistive-technology verification. |
| CI | Formatting, analysis, tests, mobile LCOV generation and Android debug build steps. | Enforced coverage threshold, published reports, real secret scanner, unsigned iOS build, separated environments and dependency automation. The iOS workflow step only prints a note. |
| Repository/release | Required documentation filenames, CONTRIBUTING, CHANGELOG and SECURITY exist. | Complete content/current claims, PR/issue templates, dependabot, named maintainers if CODEOWNERS is added, branded assets, manifests/disclosures, owned IDs/URLs, screenshots, signing/beta configuration and crash-reporting implementation. |

## Scheduling probes

A temporary Dart script outside the repository exercised the existing engine with fixed UTC instants. These observations reproduce missing behaviour; they are not new committed feature tests. The cases belong in the next approved engine implementation's regression suite.

| Input | Required observation | Actual result |
| --- | --- | --- |
| Fixed blocks 09:00–12:00, 09:30–10:00 and 10:30–11:00 | Report both overlaps involving the long block. | Only the first pair is reported; the loop compares adjacent starts. |
| Two planned, non-splittable 40-minute tasks in one 60-minute block | Report 80 minutes of work exceeding 60 minutes of capacity. | No observations; each task is checked separately. |
| Same flexible plan, “Running late” at 09:00 with 10-minute versus 60-minute duration | The different delays constrain the resulting available time. | All three preview block schedules are identical. |
| Flexible block 08:00–09:00, working window 09:00–17:00 | Report work outside its permitted working window. | No observations. |

Other source-backed limitations: `ReweaveResult.isFeasible` is calculated from the original observations, not an independent validation of each resulting preview; the reflow can retain an unplaceable block unchanged; task permitted windows and allocations are absent from the current model; and confidence uses a fixed penalty formula over observation counts rather than calibrated uncertainty. Application guards mitigate some unsafe writes but do not supply the missing solver semantics.

## Rechecked validation

| Check | Result on 26 October 2026 |
| --- | --- |
| SDK | Flutter 3.47.8 stable / Dart 3.13.7 installed. No dependency additions or latest-version/maintenance review performed for this audit. |
| Mobile tests | `flutter test --coverage`: **34 passed**, including existing widget, golden and migration cases. |
| Mobile analysis | `flutter analyze`: **no issues**. |
| Pure Dart engine | `dart test`: **7 passed**. |
| Shared domain | `dart test`: **12 passed**. |
| Design system | `flutter test`: **2 passed**. The Flutter tool's incidental analyser-configuration edit was reverted. |
| Mobile application-layer coverage | `planning_controller.dart`: **18/107 lines, 16.8%** in the newly generated LCOV. The 80% requirement is unmet. |
| Platform/release | No new Android/iOS build, signed upload, real-device accessibility/performance run, notification/calendar exercise or backend deployment was performed. Previous build evidence remains historical. |

Test pass counts establish only the behaviours actually exercised. They do not establish production readiness or resolve the scheduling counterexamples above.

## Continuation recommendation

Use the [existing phase acceptance gates](05-phases-risks-and-approval.md#phases-and-acceptance-criteria) and [implementation ledger](../implementation-status.md), not historical completion prose. Avoid rebuilding the scaffold or renaming internal packages as a prerequisite to useful local work.

1. Confirm whether the current request resumes implementation or retains the pasted first-assignment-only boundary. Preserve the current feature branch and existing work.
2. Harden timeline/tasks next in the supplied slice order: persist editable task constraints/buffers, validate commands, and make original/revised comparison plus complete supported undo durable. Verify offline/restart/cancel/error paths and application coverage.
3. Complete capture and routines: native capture boundaries, all required starters/custom storage, real reconcile previews, confirmation/undo and recurrence/exceptions. Do not claim additive insertion is conflict reconciliation.
4. Replace widget-owned focus timing with a persistent session state machine before background notifications or measurement linkage. Then add native calendar import with provider and DST tests.
5. Complete Reality Check and recovery using explicit allocation semantics and independent validation. Add the probes above as regressions, constraint-by-constraint tests and task-conservation/property checks before advertising feasible alternatives.
6. Continue calibration/insights, optional cloud/sync/sharing, platform surfaces and store readiness in the documented order. External accounts/ownership gate only the operations that require them.

These are dependency priorities, not a reduced feature commitment or a claim that the later slices are implemented.

## Decisions and open inputs

The [D1–D12 decision table](05-phases-risks-and-approval.md#decisions-requiring-approval) remains the concrete approval surface. There is no recorded approval here for consequential changes to navigation, encrypted persistence/recovery or cloud encryption boundaries.

For independent local continuation, retain existing architecture and internal Dayweft package IDs; use the brief's Calm Time product identity when the identity decision is settled. Before changing structural boundaries, settle task-versus-allocation semantics, planning-day/IANA-zone intent and the protected-break policy. Before uploading personal content or publishing links, settle cloud disclosure/encryption, owned endpoints/region and sharing semantics. Never invent production ownership, credentials, legal URLs or signing accounts.

Reference access or an explicit source-audit waiver is needed to call the React audit complete. It need not prevent independently authorised local work. The proposed Flutter [information architecture/accessibility plan](02-product-and-experience.md), [domain/entities/constraints/invariants](03-domain-and-engine.md), and [offline-first design/threat model](04-data-sync-and-threat-model.md) remain available for review alongside this comparison.
