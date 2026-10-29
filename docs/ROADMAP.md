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
| 7 Templates | Starters/custom editing, selected safe application and recurrence | IN PROGRESS | Custom library verified in local automated tests; implement recurrence/exceptions |
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
| 21 CI | Reproducible least-privilege validation, scans, builds/artifacts | IN PROGRESS | Local scripts plus actual Actions run |
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
