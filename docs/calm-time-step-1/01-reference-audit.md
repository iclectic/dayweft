# Reference product audit and retention matrix

Status: provisional. The current reference source could not be accessed on 24 October 2026.

## Evidence and scope

| Evidence | What was established | Limitation |
| --- | --- | --- |
| User's product brief | Intended React/TypeScript daily planner, feature families and greenfield Flutter direction | Describes intent; does not prove implementation |
| GitHub connector | Metadata, commits, recursive `main` tree and `src/store/plannerStore.tsx` reads returned 404 | No source inspected in this assignment |
| Direct [repository API](https://api.github.com/repos/iclectic/calm-time) | HTTP 404 after network access was permitted | Does not identify the reason for missing access |
| [Historical workspace audit](../reference-audit.md), local commit `a25319b9ca3032c130a76ff46f509b550bd8633e` | Earlier report names source paths and behaviours | No source SHA recorded; findings cannot be reproduced against that reference snapshot |
| Current local checkout | `origin` is `iclectic/dayweft`; branch `feat/dayweft-plan-completion`; Flutter packages and existing changes are present | This is a different repository; it is not evidence about the current React source |

No reference app was run. No existing source dependency, test suite, cloud configuration or licence was independently validated. Historical findings below must be rechecked when source is available; they must not be presented as confirmed vulnerabilities.

## Concise product assessment

The useful product proposition is a lightweight path from capture to a time-blocked day and then to focused work. Timeline navigation, an inbox, a multi-line brain dump and reusable day patterns support that path. Sharing and synchronisation can make it more useful across devices and responsibilities.

The historical audit describes a compact React/Vite/Tailwind/shadcn application with global planner context and browser persistence. It reports a vertical timeline, three starter templates, a timer, cloud AI helpers and Supabase-backed accounts/sharing. These are useful product lessons, not a foundation for the requested mobile implementation.

The main product gap is recovery when a plan stops fitting. A slot suggestion or opaque AI answer is insufficient: the new product needs fixed commitments, explicit task flexibility, duration accounting, protected buffers, explainable alternatives and reversible confirmation. The brief requires these behaviours regardless of what the inaccessible reference currently implements.

## Historical technical findings to verify

| Area | Earlier report | Consequence for the new design |
| --- | --- | --- |
| State and persistence | `src/store/plannerStore.tsx` uses global context and browser `localStorage`, key `eloquent-planner` | Replace storage and state boundaries; never copy browser persistence into mobile |
| Scheduling | Simple next-action/AI slot suggestions; no deterministic engine reported | Build and test a pure Dart solver independently of UI and cloud |
| Sync | Block rows deleted and reinserted | Replace with stable IDs, version preconditions, durable outbox and tombstones |
| Templates | Applying a template replaces the day's blocks | Always reconcile around commitments and preview before confirming |
| Calendar | Calendar view with Google/Outlook “coming soon” messaging | Distinguish a date picker from calendar integration; implement native import first |
| Focus | Current-block timer and task completion | Model an interruption-tolerant session with elapsed-time recovery |
| Insights | Streaks, an AI life-balance score and burnout-risk wording | Remove pressure mechanics and diagnostic framing; show explainable observations |
| Cloud AI | Cloud gateway and sign-in dependency | Basic capture, parsing, checks and recovery must work locally |
| Sharing | Public token-based selection and detailed task display | Validate actual policies before judging them; new sharing uses minimal snapshots and expiry |
| Security hygiene | A committed `.env` and content-bearing logs are reported | A `.env` alone does not prove secret leakage. Recheck key types and values privately; never reproduce secrets in reports |
| Tests/accessibility | An example test and no explicit accessibility strategy reported | Current coverage unknown; establish meaningful tests and assistive-technology verification from the start |

## Feature-retention matrix

“Retain” preserves a behaviour, not its source code or appearance. “Redesign” changes the interaction or semantics. “Replace” uses a different technical/product capability. “Remove” excludes the behaviour entirely.

| Behaviour or assumption | Decision | Flutter treatment |
| --- | --- | --- |
| Daily vertical timeline | Redesign | Native scrolling, readable hierarchy, fixed/flexible/optional labels, buffers and revision comparison |
| Week/date strip | Retain | Localised date navigation, first day of week and shift-day context |
| Quick task capture | Retain | Available without an account; capture first, optional detail later |
| Multi-line brain dump | Retain | Preserve source text until confirmed; one reviewable candidate per line |
| Task creation/editing | Redesign | Stable task identity outside blocks, estimates, constraints and typed status |
| Tasks grouped within blocks | Redesign | Separate work from time allocation; explicit sequential versus checklist semantics |
| Drag/reorder/resize | Redesign | Touch interactions plus equivalent accessible actions and immediate validation |
| Fixed time blocks | Redesign | Explicit immutability, provider provenance and scoped approval for any change |
| Cloud-only natural-language parsing | Replace | Bounded local parser with highlighted, editable interpretation |
| AI smart scheduling/briefing | Replace | Deterministic Adaptive Day Engine and Reality Check; cloud AI is not required |
| “What next?” | Redesign | Explain a feasible next action using remaining time and user preferences |
| Focus timer | Redesign | Persistent countdown/count-up session, interruptions, notifications and task outcomes |
| Templates | Redesign | Required eight starter types plus custom routines; reconcile, preview, confirm, undo |
| Existing template overwrite | Remove | No unreviewed replacement of a day |
| Internal calendar view | Replace | EventKit/Android provider read integration with per-source controls |
| Unfinished Google/Microsoft integration | Replace | Provider interfaces now; OAuth providers deferred without claiming support |
| Estimate-versus-actual observations | Redesign | Sufficient-sample calibration with uncertainty and record exclusion |
| Generic completion charts | Redesign | Plan/reality, interruptions, deferrals and protected recovery, with denominators |
| Streaks and guilt messaging | Remove | No streaks or punitive missed-day language |
| Fabricated productivity/life-balance scores | Remove | No score used as a proxy for worth or health |
| Burnout/medical-risk labels | Remove | Observational, non-medical wording only |
| Optional account | Redesign | Local planning remains complete without authentication |
| Feature/account/paid gates | Remove | No artificial premium restrictions or monetisation |
| Cloud synchronisation | Redesign | Optional, incremental, conflict-safe and transparent |
| Delete/reinsert synchronisation | Replace | Idempotent versioned operations; preserve losing/conflicting edits |
| Read-only plan sharing | Redesign | Selected snapshot/availability, titles and notes hidden, expiry and revocation |
| Export | Retain | Versioned complete local export plus separately minimised share output |
| Import | Redesign | Optional validated preview; never blindly replace the local database |
| Theme preferences | Retain | Original Material 3 light/dark tokens, system text scale and reduced motion |
| Web shortcuts | Redesign | Native hardware keyboard and switch access alongside touch |
| Browser layout/component library | Replace | Original Flutter information architecture and visual system |

## Web assumptions explicitly rejected

- A browser session is durable enough to be the sole persistence layer.
- A day is always midnight-to-midnight, exactly 24 hours, or a standard nine-to-five shift.
- Fixed-position desktop panels or hover controls are appropriate on a phone.
- Dragging is the only way to reschedule, or all text fits a fixed-height time cell.
- A continuously running UI timer is an accurate record of elapsed time.
- Internet access or sign-in is necessary for parsing, recovery or focus.
- Replacing a full day remotely is safe when two devices can edit offline.
- UTC timestamps alone describe recurring wall-clock routines or all-day calendar events.
- A calendar permission grant is permanent, or device calendar data may automatically be uploaded.
- A read-only URL is private because it is hard to discover.

## Source verification work still required

Obtain an accessible repository/commit or source archive with provenance. Record the tree/commit identity, inspect source, package manifest, licence, migrations/RLS, edge functions, logging and tests, then run the reference where practical using non-personal data. Confirm the reported paths and behaviours, trace actual capture/sync/sharing flows, and replace every historical claim with a supported finding or correction. Do not copy code/assets or import legacy data before the relevant rights and data format are understood.
