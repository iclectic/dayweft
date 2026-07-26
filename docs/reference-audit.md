# Dayweft Reference Audit

Reference inspected: `https://github.com/iclectic/calm-time`, public repo `iclectic/calm-time`, default branch `main`, repository metadata updated 2026-07-26 and last pushed 2026-02-22.

## Existing Application Summary

The reference is a compact React, TypeScript, Vite, Tailwind and shadcn/ui web app. It models a daily planner around time blocks, tasks, an inbox, templates, a focus screen, settings, cloud auth, sharing, a calendar view and AI-backed planning helpers.

The useful product intent is clear: a lightweight day planner with fast task capture, a mobile-sized timeline, recurring day templates, a focus surface, cloud sync, read-only sharing and planned external calendar aggregation. The implementation is not a migration target. Dayweft should reuse product lessons only.

## Technical Audit

| Area | Reference finding | Dayweft implication |
| --- | --- | --- |
| App architecture | Single React app with global context in `src/store/plannerStore.tsx`. | Replace with Flutter monorepo, Riverpod, feature layering and pure Dart domain packages. |
| Persistence | Browser `localStorage` key `eloquent-planner`. | Replace with Drift SQLite as local source of truth. |
| Identity and sync | Supabase auth and tables exist; sync deletes and reinserts block rows. | Redesign for optional account, stable IDs, tombstones, versions, operation queue and deterministic conflict resolution. |
| Scheduling logic | Simple "What next" and AI slot suggestions. No deterministic scheduling engine. | Build Dayweft Adaptive Engine as pure Dart package with explainable constraints and invariant tests. |
| AI usage | AI calls are cloud-only through a Lovable gateway and gated by sign-in. | Default to deterministic on-device behaviour; optional AI only with consent and clear data boundaries. |
| Timeline | Vertical mobile timeline, week strip, current block state, drag reorder, block gaps, add-task affordance. | Retain concept, redesign for native Flutter, accessibility, undo, revision history, buffers and original-vs-revised comparison. |
| Inbox | Quick capture and multi-line brain dump. | Retain and expand with local parser confirmation, voice, share-sheet and home-screen quick capture. |
| Focus | Current-block timer with pause/resume and task completion. | Redesign as Quiet Focus with count-up/countdown sessions, interruption logging, haptics, local notifications, Android foreground notification and iOS Live Activities where practical. |
| Calendar | In-app calendar picker plus "Google/Outlook coming soon" copy. | Replace with Apple EventKit and Android calendar-provider integration first; leave OAuth extension points. |
| Templates | Three templates: Weekday, Student, Weekend. Applying a template replaces the day's blocks. | Redesign with required template library and reconcile-with-preview flow. |
| Insights | Completion rate, days planned, blocks created, top categories, streaks, AI life-balance score and burnout risk. | Replace manipulative or diagnostic language with Your Rhythm observations, insufficient-data warnings and user-controlled learning records. |
| Sharing | Shared plan tokens are public-selectable by token, read-only display includes task titles and priorities. | Redesign with default private-detail hiding, expiring/revocable links, token enumeration resistance and rate limits. |
| Accessibility | UI uses semantic HTML partially by default, but no explicit WCAG plan, keyboard/switch model, reduced motion or localisation strategy. | Build accessibility requirements into acceptance criteria from phase 1. |
| Security | RLS policies exist, but `.env` is committed in repo tree, sharing endpoint is broad public SELECT, and sync logs can include personal content. | No committed secrets, least-privilege sharing, private logging, privacy manifests, secure storage and threat model from start. |
| Tests | Only example Vitest setup/test appears. | Dayweft needs engine, domain, persistence, widget, integration, accessibility, timezone/DST and sync conflict tests. |

## Retain, Redesign, Replace or Remove Matrix

| Reference feature | Decision | Reason |
| --- | --- | --- |
| Vertical daily timeline | Redesign | Strong core concept; needs native mobile interactions, revision history, buffers, fixed/flexible/optional semantics and accessibility. |
| Week strip date navigation | Retain | Useful mobile navigation pattern; implement with localised first day of week. |
| Time block creation | Redesign | Keep fast creation; add validation, block types, estimated/actual duration, deadlines, buffers and undo. |
| Drag reorder | Redesign | Keep direct manipulation; pair with accessible reorder controls and schedule invariant checks. |
| Tasks inside blocks | Redesign | Keep nested work model; add tasks outside blocks, dependencies, minimum useful durations and split permissions. |
| Inbox | Retain | Essential capture pattern. |
| Brain dump | Retain | Good fit for calm capture; expand parser and confirmation. |
| Cloud-only NLP input | Replace | Basic parsing must work offline and always show confirmation. |
| AI daily briefing | Replace | Reframe as deterministic Reality Check observations; optional AI later only with consent. |
| AI smart scheduling | Replace | Build deterministic Dayweft Adaptive Engine first. |
| "What next?" | Redesign | Keep as explainable next-step suggestion, not opaque AI. |
| Focus mode | Redesign | Keep focus surface; expand into Quiet Focus with sessions, interruptions and platform support. |
| Templates | Redesign | Existing overwrite behaviour is unsafe; Dayweft must reconcile and preview. |
| Calendar view | Replace | Reference has no real calendar integration; implement native platform calendar import. |
| Insights charts | Redesign | Keep trends, remove scores/streaks/diagnostic labels. |
| Day streak | Remove | Conflicts with no manipulative streaks. |
| Burnout risk and signals | Remove | Conflicts with no medical, therapeutic or diagnostic claims. |
| Completion percentage as core success | Redesign | Can exist as factual context, but not as productivity score or moralised metric. |
| Account-gated AI/features | Remove | All user-facing features must be free; account optional only for sync/sharing. |
| Supabase auth | Redesign | Keep optional Supabase account direction, but local-only must be first-class. |
| Delete-and-reinsert sync | Replace | Unsafe for offline-first conflict handling. |
| Read-only shared plan | Redesign | Keep sharing intent; default to hiding private task details. |
| Keyboard shortcuts | Redesign | Less central on mobile, but keep hardware keyboard accessibility where useful. |
| Data export/import | Retain | Required privacy feature; implement with schema versioning and redaction controls. |
| Theme toggle | Retain | Expand to Material 3 light/dark, text scale and reduced motion. |

## Brand And Rename Inventory

These existing reference strings must eventually be replaced or reworked when any content is ported or used as planning reference:

| File | Reference |
| --- | --- |
| `README.md:1` | `# Daily Planner` |
| `src/store/plannerStore.tsx:45` | `const STORAGE_KEY = 'eloquent-planner';` |
| `index.html:6` | `Eloquent Daily Planner` title |
| `index.html:7` | `daily planner` meta description |
| `index.html:8` | `Eloquent` author |
| `index.html:11` | `Eloquent Daily Planner` Open Graph title |
| `src/pages/SharedPlan.tsx:175` | `Eloquent Daily Planner · Shared view` |
| `src/pages/CalendarView.tsx:77` | `your Eloquent time blocks` |
| `supabase/functions/ai-planner/index.ts:26` | `daily planner app` |
| `supabase/functions/ai-planner/index.ts:58` | `daily planner` |
| `src/pages/Settings.tsx:30` | `localStorage.getItem('eloquent-planner')` |
| `src/pages/Settings.tsx:36` | `eloquent-planner-...json` export filename |
| `src/pages/Settings.tsx:53` | `localStorage.setItem('eloquent-planner', ...)` |
| `src/pages/Settings.tsx:224` | `Eloquent Daily Planner · Plan clearly. Live calmly.` |

No exact `Calm Time` text was found in the reference source tree.

## Reference Risks To Avoid

- Do not commit environment files or secrets.
- Do not claim encryption unless the exact encryption model is implemented and documented.
- Do not gate core planning, parsing or adaptive scheduling behind account creation.
- Do not send task titles, notes or calendar titles to analytics.
- Do not use health-risk, burnout-risk or diagnostic language.
- Do not overwrite a plan when applying a template.
- Do not sync by deleting and recreating rows.
- Do not expose public share rows broadly without rate limits, expiry and least-detail defaults.
- Do not rely on AI outputs for schedule correctness or invariant preservation.
