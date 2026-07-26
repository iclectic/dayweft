# Dayweft Phased Implementation Plan

## Phase 1: Requirements And Architecture

Acceptance criteria:

- Reference audit and retain/redesign/replace/remove matrix completed.
- Product requirements approved.
- Mobile information architecture approved.
- Initial domain entities documented.
- Adaptive Engine constraints and invariants documented.
- Offline-first database and sync design documented.
- Accessibility plan documented.
- Privacy and security threat model documented.
- Risk register and approval decisions documented.
- No production code written.

## Phase 2: Workspace, Engine Shell, Design System, CI And Database

Acceptance criteria:

- Flutter monorepo created with `apps/dayweft_mobile`, `packages/adaptive_day_engine`, `packages/dayweft_design_system` and `packages/dayweft_domain`.
- Strict analysis options configured.
- Flutter app boots on iOS and Android simulators.
- Riverpod and go_router bootstrap in place.
- Drift database v1 migration created and tested.
- Design tokens, light/dark themes and base components created.
- CI verifies formatting, analysis, tests, coverage, secrets and Android build; iOS build documented or enabled where signing permits.
- README distinguishes implemented versus planned functionality.

## Phase 3: Local Planning MVP

Acceptance criteria:

- Onboarding supports local-first explanation, skippable steps and removable sample data.
- Today Timeline supports create, edit, resize, reorder and delete for local blocks.
- Tasks can be created inside and outside blocks and moved between blocks.
- Inbox and brain dump work offline.
- Basic offline natural-language parsing shows confirmation before save.
- Templates can be previewed and reconciled with existing commitments.
- Manual undo and revision history exist for local planning changes.
- Widget, domain, database and accessibility tests cover the MVP.

Current status:

- Local-first onboarding, removable sample data, Drift-backed Today Timeline, Inbox, Brain Dump, parser confirmation, template preview/application, revision history and local undo are implemented.
- Drag gestures, export/import and broader accessibility/golden coverage remain follow-up Phase 3 hardening work.

## Phase 4: Adaptive Engine, Reality Check And Reweave My Day

Acceptance criteria:

- Pure Dart engine generates deterministic Reality Check observations.
- Engine generates up to three named alternatives.
- Fixed commitments, deadlines, dependencies, buffers, permitted windows, split rules and minimum durations are enforced.
- Each change includes explanation, trade-off and confidence.
- Alternatives are preview-only until confirmation.
- Confirmed changes are reversible.
- Scheduling invariant and property-based tests pass.

## Phase 5: Estimation, Energy And Your Rhythm

Acceptance criteria:

- Estimate-versus-actual records are captured with exclusion and deletion controls.
- Calibration appears only after sufficient sample size.
- Energy-aware planning is opt-in and deletable.
- Your Rhythm shows observations, trends and insufficient-data states.
- No arbitrary productivity scores, streaks or health claims appear.
- Tests cover estimation thresholds, uncertainty and data deletion.

## Phase 6: Optional Sync And Sharing

Acceptance criteria:

- Account creation is optional and local mode remains fully usable.
- Sync queue saves locally first, retries safely and handles conflicts without erasing local work.
- Sync status is visible but non-blocking.
- Sharing supports read-only day, selected blocks, availability-only and templates.
- Links expire and can be revoked.
- Public endpoints hide private details by default and resist token enumeration.
- Sync conflict and sharing security tests pass.

## Phase 7: Platform Integrations, Accessibility And Store Readiness

Acceptance criteria:

- Apple EventKit and Android calendar-provider import work read-only by default.
- Optional calendar writes require explicit permission.
- Recurrence, timezone and DST test fixtures pass.
- Quiet Focus supports local notifications, haptics and platform-specific foreground/live surfaces where practical.
- Home-screen quick capture and widgets are implemented where platform support permits.
- Accessibility audit passes target criteria.
- App identifiers, icons, splash screen, privacy manifest, permission copy, screenshots, release signing docs, semantic versioning, crash reporting policy, review notes and demonstration data are ready.

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
| --- | --- | --- | --- |
| Adaptive scheduling scope grows too broad | High | High | Ship deterministic core first; enforce phase acceptance criteria. |
| Calendar timezone and DST bugs | Medium | High | Model event intent explicitly; add fixtures early. |
| Offline sync conflicts cause data loss | Medium | High | Operation queue, tombstones, append-only revisions and conflict tests. |
| AI/privacy expectations conflict | Medium | High | Local deterministic features first; explicit AI consent and payload preview. |
| Accessibility retrofitting becomes expensive | Medium | High | Include semantics, text scaling and non-drag alternatives from MVP. |
| Engine explanations become misleading | Medium | High | Generate explanations from rule decisions, not free text. |
| Supabase sharing exposes too much | Medium | High | Redacted views/functions, hashed tokens, rate limits and expiry. |
| Platform-specific integrations delay release | Medium | Medium | Feature flags and graceful degradation. |
| Large dependency surface increases maintenance | Medium | Medium | Dependency review gate before adding packages. |
| Store privacy requirements change | Medium | Medium | Treat app-store readiness as a phase with current review before submission. |

## Decisions Requiring Approval

- Whether to approve this requirements baseline.
- Whether Dayweft should scaffold the full monorepo next or start with only the local MVP slice.
- Minimum sample threshold for estimation calibration; proposed default: 12 completed records per category/time bucket before showing a factor.
- Default utilisation threshold for Reality Check; proposed default: observe above 80% planned utilisation and warn strongly above 90%.
- Default transition buffer; proposed default: 10 minutes between demanding blocks, user-adjustable.
- Whether optional cloud AI is allowed in later phases, and what consent language is required.
- Whether sharing should initially support public links or start with local export/share-sheet only.
- Initial calendar write support timing; proposed default: read-only calendar integration before any write capability.
- Whether sample data should be installed by default or offered as an onboarding toggle; proposed default: offer, do not auto-install.
