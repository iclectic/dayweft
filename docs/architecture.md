# Dayweft Architecture

## Monorepo

```text
dayweft/
  apps/
    dayweft_mobile/
  packages/
    adaptive_day_engine/
    dayweft_design_system/
    dayweft_domain/
```

## Technology Baseline

- Flutter stable and Dart stable.
- Material 3.
- Riverpod for state management.
- go_router for navigation.
- Drift and SQLite as local source of truth.
- Freezed and json_serializable for immutable models and JSON boundaries.
- Supabase for optional auth, sync and sharing.
- flutter_secure_storage for secrets and local credential material.
- local_auth for biometric app lock.
- timezone and platform calendar APIs for time correctness.
- flutter_local_notifications for local notification support.

Dependency additions require a documented check for maintenance, licence, platform support, release history and whether the feature can reasonably be implemented without the dependency.

## Package Responsibilities

### `adaptive_day_engine`

Pure Dart. No Flutter, Drift, Supabase or UI dependencies. Owns feasibility checks, schedule alternatives, explanations, confidence, learning summaries and invariants.

### `dayweft_domain`

Pure Dart domain model shared by app and tests: tasks, blocks, calendars, revisions, privacy settings, sync envelopes, failures and value objects.

### `dayweft_design_system`

Flutter package for Dayweft visual identity, tokens, components, motion durations, typography, timeline motifs, dark mode and accessibility helpers.

### `dayweft_mobile`

Flutter iOS and Android app. Owns bootstrap, routing, local database, platform integrations, notifications, sync adapters and feature presentation.

## Mobile App Structure

```text
lib/
  app/
    bootstrap/
    routing/
    theme/
  core/
    accessibility/
    database/
    errors/
    logging/
    notifications/
    privacy/
    sync/
    time/
    widgets/
  features/
    onboarding/
    timeline/
    tasks/
    inbox/
    quiet_focus/
    adaptive_planning/
    calendar/
    templates/
    your_rhythm/
    sharing/
    settings/
```

Substantial features use data, domain, application and presentation layers. Domain logic must not live in widgets.

## Information Architecture

Primary bottom navigation:

- Today: Today Timeline, current plan, Reality Check summary and Reweave My Day entry.
- Inbox: quick capture, brain dump, parsed confirmations and unscheduled tasks.
- Quiet Focus: current or chosen focus session.
- Your Rhythm: observations, trends and reflections.
- Settings: privacy, sync, calendars, notifications, data and accessibility.

Secondary surfaces:

- Templates reachable from Today and Settings.
- Calendar reachable from Today and Settings.
- Sharing reachable from Today, block overflow menus and templates.
- Onboarding shown only until dismissed, with all steps skippable.

## Design System Direction

Dayweft should feel calm but operational. Use warm neutral backgrounds, a distinctive adaptive accent, thread-like timeline connections and restrained woven motifs. Avoid making every section a card. Use full-width bands and native mobile sheets for workflows, and keep cards for repeated items, dialogs and focused tools.

The logo should be a simple woven day-thread mark, not an intricate decorative illustration. Timeline connections, reweave previews and revision comparisons are the main places for the weaving metaphor.

## Configuration

Use separate development, staging and production configuration. No committed secrets. The app must start in local-only mode when cloud configuration is absent.

## Logging

Structured logs only. Do not log task titles, notes, calendar titles, focus-session content or personal schedule descriptions. Include event type, failure code, component, non-personal counts and timings.

## Dayweft 1.0 continuation

The existing feature-first Flutter/Riverpod/go_router/Drift architecture is retained. The clock is now injected through Riverpod and repository constructors. Selected civil dates scope planning commands and revision history; Inbox remains global. Day navigation uses civil components, not a fixed 24-hour duration. The pure Dart engine still has no persistence or network access. See [current architecture review](audit/architecture-review.md) and [roadmap](ROADMAP.md) for unresolved native/cloud/allocation boundaries.
