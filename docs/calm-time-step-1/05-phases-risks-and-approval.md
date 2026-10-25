# Phased implementation, risks and approval decisions

Status: proposed release gates. The user subsequently authorised continuing unfinished implementation; [implementation status](../implementation-status.md) records actual work. “Phase” is a dependency/acceptance boundary, not a time estimate.

## Phases and acceptance criteria

Each slice requires domain logic, local persistence/migrations, UI, loading/empty/error/offline states, accessibility verification and updated implemented/planned documentation. Relevant automated checks must pass before advancing dependent work. Do not substitute table/route scaffolds for the capability.

| Phase | Scope in the requested order | Acceptance gate |
| --- | --- | --- |
| 0 | Complete reference evidence and detailed Step 2 requirements/domain/ADRs | Pin source commit or record explicit waiver; settle consequential decisions; trace every required feature to a release gate; no unsupported implementation claims |
| 1 | Foundations / Step 3 | Compatible stable SDK/dependency inventory; feature-first boundaries and pure Dart engine; strict analysis; dev/staging/prod configuration; real migration fixtures; M3 token spec; CI format/analyse/tests/coverage/secret scan and Android plus unsigned iOS builds where runner permits |
| 2 | Local onboarding | All choices persisted and editable; each step/all setup skippable; samples opt-in/removable without losing personal work; no launch permission prompts; restart/offline and large-text journeys pass |
| 3 | Local timeline/tasks | Create/edit/resize/reorder/delete, tasks inside/outside blocks and task movement; full constraint fields and buffers; current time, date/shift handling, original/revised comparison; positive durations and task conservation; all supported commands have durable undo/history |
| 4 | Inbox/brain dump | Fast local drafts; confirmed editable date/time/duration/priority/energy/category; multi-line review; voice capability detection and text fallback; native share-sheet capture; no parsed field dropped between preview and persistence |
| 5 | Templates/routines | Eight required starter types and custom templates; recurrence/exceptions; deterministic reconciliation with existing commitments; no overwrite or duplicate materialisation; confirm/apply/undo survives restart |
| 6 | Focus | Countdown/count-up, task/subtasks, pause/resume/complete/abandon and interruption history; elapsed time survives background/restart; task completion explicit; contextual notification/haptic choices and offline operation |
| 7 | Calendar import | Real EventKit/Android-provider capability/permissions and per-calendar selection; read-only app default, clear sources; recurrence/exceptions, denied/revoked recovery and DST/night-shift tests; provider ports support later OAuth adapters |
| 8 | Reality Check | Overlaps, utilisation denominator, transitions, required breaks, deadline combinations and demanding clusters; hard/soft distinction; concrete affected intervals and corrective choices; no fabricated score |
| 9 | Disruption recovery | All seven required disruption types affect actual constraints; up to three independently valid alternatives; fixed events protected, windows/deadlines/dependencies/buffers/splits enforced; transparent reasons/evidence/trade-offs; reject/cancel changes nothing; accepted decisions and undo durable |
| 10 | Estimation and optional energy | Genuine estimates/actuals with provenance, category/time/day/interruption/split context; sufficient-sample factors and spread; inspect/exclude/delete; energy disabled means no collection/use; no health claims |
| 11 | Insights | Estimate/actual trends, deferred categories, baseline/reality, disruption/interruptions, protected recovery, acceptance denominator and weekly reflection; insufficient evidence is explicit; complete data export works offline |
| 12 | Optional account/sync | Local mode still complete; secure auth lifecycle, account-link preview, atomic outbox, retry/idempotency/cursors/tombstones; concurrent/offline deletion tests; conflicts preserve local work; owner RLS tests and remote account deletion pass |
| 13 | Sharing | Exact selected/minimised snapshot preview; availability and templates; validated expiring/revocable HTTPS links; anonymous viewer isolated from owner tables; cryptographic digest storage, limits, hostile-input and RLS tests |
| 14 | Widgets/platform completion | Android foreground-session notification under current platform policy, iOS Live Activities where supported, home-screen widgets/quick capture, optional approved calendar writes; locked/unsupported/denied cases degrade gracefully; no dependency on internet for focus |
| 15 | Store readiness | Owned IDs/URLs, branded icons/splash and real screenshots; localisation-ready metadata, manifests/disclosures/usage strings, export/account deletion, consent-based crash reporting; signed TestFlight/Play internal builds and reviewer demonstration tested; no monetisation mechanisms |

Required starter routines: Workday, Study day, Night-shift day, Recovery day, Conference day, Travel day, Content-creation day and Personal-administration day. Platform notification surfaces begin in focus and are completed in the platform phase; they are not waived by dividing the work.

## Cross-cutting verification gate

- Maintain at least 80% measured domain/application coverage, separately visible for engine, shared domain and app application logic; do not inflate it with trivial UI tests.
- Unit-test each constraint; add independent-oracle/seeded property tests for hard invariants and task conservation. Preserve failing seeds.
- Widget-test principal commands, confirmation/cancellation, parsing persistence, stale proposals, permission/error/offline states and undo. Golden-test Today, capture, recovery, focus and settings in light/dark and large text; golden updates require visual inspection.
- Integration-test fresh local start → capture → schedule → focus → disruption → confirm → restart → undo, plus template reconciliation and optional sync across two clients.
- Test historical database upgrades with actual rows; permission revocation; calendar recurrence; spring gaps/autumn folds; night shifts; foreground/background clock behaviour; and conflict/deletion retry races.
- Manually verify VoiceOver, TalkBack, keyboard and switch journeys on representative iOS/Android devices. Profile scrolling/recovery off the UI isolate on a named mid-range device. Record measured frame timings and solver latency; do not promise “no dropped frames” without traces.
- CI must fail on format/analyser errors, failed tests, coverage gates or secrets. Use locked SDK versions, safe dependency caches, pinned action identities, least-privilege workflow tokens and a reproducible golden environment.

## Documentation and release deliverables

Keep the requested README, product requirements, architecture, engine, data model, privacy/security, accessibility, testing, release process, analytics catalogue, ADRs, CONTRIBUTING, CHANGELOG and SECURITY documents. The existing versions are starting material, not proof of completion. README must reflect the implementation ledger. Add issue/PR templates, dependabot, an appropriate ownership file once maintainers are known, a release-note process and signing documentation.

Analytics is disabled without consent. Version the allowlisted event schema for onboarding completed, first plan created, block created, focus completed, recovery requested, suggestion displayed/accepted/rejected/undone, calendar connected and template applied. Document every property. Use counts, durations, enumerated source/status and schema version; never titles, notes, calendar names, free text, share tokens or user-generated category labels. Local operational history is distinct from transmitted analytics.

No remote feature is enabled solely by adding credentials to a build. Shipping needs tested RLS, deletion, abuse limits, consent/disclosures and environment separation. No signed store upload, production backend deployment or public endpoint is represented as complete without evidence.

## Initial risk register

| Risk | Impact / likelihood | Mitigation and decision gate |
| --- | --- | --- |
| Reference inaccessible; historical claims wrong | High / current | Restore source access or obtain explicit audit waiver; record exact evidence before reuse |
| Existing Dayweft code confused with a fresh Calm Time implementation | High / current | Preserve user changes, retain internal package IDs initially, track capability gaps and settle repository/display/release identity |
| Solver presents plausible but invalid schedules | Critical / high | Independent validator, proof/search-limit distinction, bounded reproducible search, fixed/task-conservation tests; never apply partial fallback |
| Splitting/defer/shorten silently loses work | Critical / high | Task/allocation separation, explicit remainder accounting and accepted inverse changes |
| Sync erases an offline creation or resurrects deleted content | Critical / medium | Atomic outbox, idempotent server operations, conflict preservation, tombstones/account epochs and stale-device tests |
| Database key loss prevents recovery | High / medium if encrypted | Decide key/backup/recovery policy before encrypted-storage rollout; test locked-device and restore paths |
| Calendar permission UX implies less access than OS grants | High / medium | Explain EventKit full-access requirement and enforce app-level read-only behaviour; test writes remain disabled |
| Night shifts and DST change intent | High / high | Explicit temporal types, IANA zones, recurrence exceptions and transition fixtures before calendar/sync |
| “Learning” appears more certain than evidence allows | High / high | Genuine measured provenance, minimum cohorts, empirical spread, explanations, exclusions and no medical interpretation |
| Native timers/widgets leak content or fail in background | High / medium | Generic locked-device defaults, capability-specific state machines, persistent time anchors and real-device tests |
| Cloud privacy promise exceeds actual encryption | High / medium | Disclose operator visibility; separate encrypted-at-rest/TLS from E2EE; do not make unimplemented claims |
| Public shares expose private details or enable enumeration | Critical / medium | Explicit snapshot preview, hidden text by default, hashed high-entropy tokens, endpoint limits and deny tests |
| Free cloud service cannot be operated sustainably | High / medium | Establish operator budget/capacity plan; preserve complete local use during outages; no user monetisation or artificial premium gates |
| Platform/dependency/store requirements change | Medium / high | Revalidate official docs and package licences at implementation/release; maintain native adapters and honest capability reporting |
| Coverage/goldens mask interaction failures | High / medium | Real repository/application integration tests, independent engine oracle, device accessibility/performance verification |

## Decisions requiring approval

The supplied stack, free feature policy, optional account and confirmation/undo guarantees are requirements, not choices to renegotiate. The following decisions are recommendations with material consequences:

| ID | Recommendation | Alternative and consequence | Needed before |
| --- | --- | --- | --- |
| D1 | Continue improving the existing checkout, displaying **Calm Time**, retaining internal Dayweft package names temporarily | A separate new repository/root avoids legacy structure but requires selecting a writable destination and moving work deliberately | Release identity or structural rename |
| D2 | Restore access to the reference repository or provide a source snapshot with commit identity | Explicitly waive a fresh source audit and use the supplied brief/historical report, with that limitation recorded | Claiming the source audit complete or reusing code/assets |
| D3 | Four primary destinations: Today, Inbox, Routines, Insights; Focus contextual and Settings in toolbar | Retain existing five-tab MVP; less navigation change but more permanent chrome and routines remain harder to find | Navigation redesign |
| D4 | Device-protected encrypted SQLite with explicit export/sync recovery, subject to a compatibility spike | OS-protected SQLite without added encryption is simpler; disclosures must accurately state protection and backup behaviour | Encrypted persistence/backup/app-lock integration |
| D5 | Optional v1 Supabase sync with clear operator-readable data disclosure; no E2EE claim | E2EE before cloud release changes key recovery, conflict handling and public sharing substantially | Uploading personal content remotely |
| D6 | Preserve the existing 12-measured-record calibration threshold; show median and empirical spread; sparse finer cohorts stay hidden | Different thresholds/methods need evidence and explicit uncertainty language; no three-record inference | Freezing calibration policy (12-record safety baseline currently used) |
| D7 | Keep Reality Check thresholds editable and observational: existing 80% utilisation warning, 10-minute transitions, 20-minute preferred break | The Step 1 design sketch suggested 85%; choose one documented policy before a final requirements baseline; neither is a health/productivity score | Policy/UX sign-off |
| D8 | Calendar import first; writing app-owned events later, with per-operation preview and separate permission | Broader writes to imported events increase provider-conflict and undo risks | Enabling calendar writes |
| D9 | Public sharing uses selected static snapshots with hidden private text and a proposed seven-day editable expiry | Live share updates or different expiry require explicit re-publication/privacy rules | Public sharing release |
| D10 | No cloud AI in the first complete release; local parsing/solver satisfy core behaviour | Optional cloud augmentation later requires payload preview, consent, provider retention and an approved data boundary | Any AI network transmission |
| D11 | Select owned production application-ID prefix, support/privacy/sharing HTTPS domain, legal operator and cloud region | Placeholder IDs/URLs suffice only for development; ownership must not be invented | Production configuration, entitlements, universal links and store metadata |
| D12 | Choose supported OS floors after validating the stable Flutter/native dependencies and accessibility test devices | A broader older-OS range adds fallback code/testing; latest features remain capability-gated | Platform build matrix |

Other open inputs: initial supported languages (English proposed, all strings localisation-ready), cloud operational owner/budget, account authentication methods, privacy/history retention and backup deletion policy, crash-reporting provider, signing/developer accounts and named repository maintainers for CODEOWNERS. These are explicit release inputs, not reasons to block unrelated local work.
