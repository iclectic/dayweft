# Dayweft Data Model And Sync Design

## Local Source Of Truth

Drift SQLite is the source of truth. Every change is saved locally before any remote operation. Cloud sync is an optional adapter over local state, not the primary model.

## Initial Domain Entities

- UserProfile: local profile, account linkage and privacy mode.
- UserPreferences: working hours, wake/wind-down, planning style, time format, locale, first day of week, motion and text-size preferences.
- CalendarSource: platform calendar, optional cloud calendar, permission state and source indicators.
- CalendarEvent: imported fixed commitment with recurrence and timezone metadata.
- DayPlan: date, timezone, working windows, planning state and active revision.
- TimeBlock: fixed, flexible or optional block with start/end, buffers, source, category and tasks.
- Task: title, notes, priority, category, deadline, estimate, actuals, energy, cognitive load, dependencies, split policy and status.
- TaskDependency: prerequisite relation between tasks.
- Buffer: travel, preparation, transition or recovery reserve.
- Disruption: user-reported change event.
- RealityObservation: concrete feasibility finding.
- ReweaveAlternative: proposed schedule, explanations, trade-offs and confidence.
- ScheduleRevision: reversible diff from original to revised plan.
- UndoRecord: inverse operation set.
- EstimationRecord: estimate/actual evidence with exclusion flag.
- EnergyCheckIn: optional low/steady/high value with deletion controls.
- FocusSession: Quiet Focus run, interruptions and completion state.
- Template: reusable plan pattern with reconciliation rules.
- ShareLink: scoped public access token, expiry, revocation and redaction policy.
- SyncOperation: local operation queue item.
- SyncConflict: deterministic resolution record.
- AuditEvent: privacy-safe local event for user-visible history.

## Drift Tables

Initial tables should include:

- `app_metadata`
- `user_profiles`
- `user_preferences`
- `calendar_sources`
- `calendar_events`
- `day_plans`
- `time_blocks`
- `tasks`
- `task_dependencies`
- `buffers`
- `disruptions`
- `reality_observations`
- `reweave_alternatives`
- `schedule_revisions`
- `estimation_records`
- `energy_check_ins`
- `focus_sessions`
- `focus_interruptions`
- `templates`
- `share_links`
- `sync_operations`
- `sync_conflicts`
- `analytics_consent`
- `privacy_actions`

All user data rows should include stable UUID, local version, remote version where applicable, created timestamp, updated timestamp, soft-delete timestamp and sync state.

## Synchronisation

- Generate stable UUIDs on device.
- Queue remote operations after local commit.
- Use operation types: create, update, softDelete, restore, applyRevision, revokeShare and settingsChange.
- Retry with exponential backoff and jitter.
- Keep tombstones long enough to propagate deletions across devices.
- Never let remote state erase unsynced local work.
- Resolve conflicts deterministically by entity type:
  - Fixed commitments from calendar source preserve source intent.
  - User edits beat imported calendar metadata except source-owned fields.
  - Later version wins only for scalar preference fields.
  - Task completion merges as complete if any device marked complete, unless a later explicit undo exists.
  - Schedule revisions are append-only and conflicts create a reviewable conflict record.
- Display sync state without blocking use.

## Sharing

Share links must be scoped by resource, token hash, expiry, revocation state and redaction policy. Public endpoints must not expose owner identity, hidden task details, notes or calendar titles by default. Tokens must be high entropy and rate-limited.

## Migration Rules

Current schema: v12. The v11-to-v12 upgrade adds `saved_templates`: stable identity, name, versioned block JSON format, local version, creation/update timestamps and deletion tombstone. Each custom block retains a stable identity and the four internal buffers. Creating, updating, duplicating, deleting and restoring are transactional; stale versions cannot overwrite newer changes. Deletion undo uses the tombstone version and also survives repository/database recreation. Up to 500 active templates and 100 blocks per template are supported. Custom templates contain block settings, not task details, notes or source provenance. The existing single-day export is not a backup of this library; complete-device backup is still unfinished.

The v10-to-v11 upgrade adds `focus_session_states` with elapsed milliseconds, monotonic anchor, boot token, mode, original estimate and version. A partial unique index allows one active session. Legacy completed records survive without invented timing anchors. The v9-to-v10 upgrade adds nullable `tasks.cognitive_load` and non-null `tasks.dependency_ids_json` with an empty-list default. Application validation checks active predecessor identities and cycles. Local export/import preserves these fields and remaps predecessor IDs for imported copies. Task/block edits use local-version preconditions and increment versions on writes and undo.

Tests cover preserved records through v5, v8, v9, v10 and v11 upgrade fixtures. The v11 fixture checks actual saved Focus rows, elapsed time and versions after reopening the SQLite file. This migration does not delete or reinterpret existing rows. Rollback should use a forward-compatible repair/release; do not lower `user_version` on a user's database or discard their database to roll back the app.

Start database migrations in phase 2. Every schema change gets migration tests, downgrade/export compatibility notes where practical and fixtures for existing local data.
