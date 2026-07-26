# Dayweft Product Requirements

## Product

Public name: Dayweft: Adaptive Day Planner

Tagline: A day that adapts with you.

Dayweft is a privacy-first adaptive day planner for people whose days regularly change. It helps users create realistic plans, notice when a plan is becoming infeasible and calmly reweave the schedule with explicit trade-offs and user confirmation.

## Principles

- Local-first and offline-first by default.
- Account optional for local use.
- Cloud sync and sharing optional.
- Every user-facing feature is free.
- No ads, subscriptions, in-app purchases, donations or sale of personal information.
- Explainable recommendations before automation.
- User confirmation before schedule changes.
- Reversible automated and manual changes.
- No arbitrary productivity scores, streak pressure or health diagnoses.
- Graceful degradation when permissions, network or cloud services are unavailable.

## Target Users

Shift workers, students, developers, knowledge workers, freelancers, carers, people balancing multiple responsibilities and anyone whose planned day is often interrupted.

## Core Journeys

1. New user starts locally, skips any onboarding step, reviews removable sample data and creates a first day plan.
2. User captures tasks quickly through inbox, brain dump, voice, share sheet or home-screen quick capture.
3. User builds a Today Timeline with fixed, flexible and optional blocks.
4. Reality Check flags concrete feasibility issues without scoring the user.
5. User reports a disruption and reviews up to three Reweave My Day alternatives: Protect Essentials, Balanced Reweave and Reduce Pressure.
6. User confirms one alternative, sees an explanation and can undo it.
7. Quiet Focus runs fully offline for a current task or custom session.
8. Your Rhythm shows trends only when enough evidence exists and lets users delete learning history.
9. User optionally connects calendars, sync, account and sharing without blocking local planning.

## Functional Requirements

### Onboarding

- Explain local-first storage and optional cloud sync.
- Collect working hours, wake time, wind-down time, calendar preferences and planning style.
- Make every step skippable.
- Provide removable sample data.
- Request platform permissions only at point of need.

### Today Timeline

- Vertical mobile timeline with current-time indicator.
- Create, edit, resize, reorder and delete time blocks.
- Create tasks inside or outside blocks and move tasks between blocks.
- Support fixed, flexible and optional blocks.
- Track priority, category, deadline, notes, estimated duration, actual duration, energy, cognitive load and buffers.
- Show original versus revised plan comparison.
- Preserve complete schedule revision history.
- Provide undo for automated and manual changes.

### Inbox And Brain Dump

- Rapid task capture.
- Multi-line brain dump.
- Voice capture.
- Share-sheet and home-screen quick capture.
- Natural-language parsing for dates, times, duration, deadline, priority, energy and category.
- Offline parser first; optional cloud parser later only with consent.
- Parsed values must always be shown for confirmation.

### Reweave My Day

- Disruption types: Running late, Meeting overran, Task took longer than expected, New urgent task, Energy changed, Need a break, Missed part of the day and Custom disruption.
- Generate up to three alternatives: Protect Essentials, Balanced Reweave and Reduce Pressure.
- For each alternative show changed items, protected items, deferred items, rationale, constraints, trade-offs, confidence, preview, confirm and undo.
- Never apply changes without confirmation.

### Reality Check

- Detect overlaps, excessive utilisation, insufficient transitions, missing breaks, impossible deadlines, demanding-task clusters, insufficient travel time, oversized tasks and inadequate contingency.
- Present concrete observations and recommended actions, not scores.

### Time Estimation Calibration

- Record estimated duration, actual duration, category, time of day, day of week, interruptions, split status and optional difficulty.
- Calculate personal estimation factors only after minimum sample thresholds are met.
- Show sample size, uncertainty, supporting observations and controls to exclude or delete records.

### Energy-Aware Planning

- Optional low, steady or high check-in.
- Optional task energy and cognitive-load requirements.
- Use only when enabled.
- Explain how energy affected suggestions.
- Allow disabling and deletion.
- Never infer or diagnose health conditions.

### Quiet Focus

- Countdown and count-up sessions.
- Current task, subtasks, pause, resume, complete and abandon.
- Interruption logging, haptics, local notifications, Android foreground notification, iOS Live Activities where supported, home-screen widgets and optional bundled ambient audio.
- Fully offline operation.

### Templates

- Include Workday, Study day, Night-shift day, Recovery day, Conference day, Travel day, Content-creation day, Personal-administration day and Custom templates.
- Applying a template must reconcile with existing commitments and require preview confirmation.

### Calendar

- Apple EventKit and Android calendar provider integration.
- Read-only import by default, optional calendar writes.
- Multiple calendars, per-calendar controls, conflicts, recurring events, time-zone and daylight-saving correctness, event-source indicators and revoked-permission recovery.
- Extension points for future Google and Microsoft OAuth.

### Your Rhythm

- Show estimate-versus-actual trends, plan-versus-reality comparisons, frequently deferred categories, interruption patterns, disrupted periods, protected recovery time, successful reweaves, suggestion acceptance, weekly reflections and insufficient-data warnings.

### Sharing

- Share a read-only day, selected blocks, availability without task details and templates.
- Expiring links, revocation, private details hidden by default, token enumeration resistance and rate limits.

### Settings And Privacy

- Local-only mode, optional account and sync, biometric app lock, notification settings, calendar controls, analytics consent, AI controls, data export, learning-history deletion, cloud account deletion, theme/text-size/reduced-motion controls, 12/24-hour format, privacy policy and open-source licences.

## Non-Goals

- No React migration.
- No web app in phase 1-4.
- No ML model in the initial scheduler.
- No subscription, ad, donation or monetisation system.
- No diagnostic wellness claims.
- No cloud requirement for local planning.
