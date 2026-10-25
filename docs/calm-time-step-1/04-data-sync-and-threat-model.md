# Offline data, synchronisation and threat model

Status: proposed architecture. Most cloud/platform controls below are acceptance criteria, not implemented capabilities. See [implementation status](../implementation-status.md) for source-backed progress.

## Architecture and dependency direction

Use the required feature-first structure: `app/bootstrap`, `app/routing`, `app/theme`; `core/database`, `errors`, `notifications`, `privacy`, `sync`, `time`, `widgets`; and features for onboarding, timeline, tasks, inbox, focus, adaptive planning, calendar, templates, insights, sharing and settings. Substantial features have domain, application, data and presentation layers. The existing monorepo can host this structure without a second scaffold.

The app composes Riverpod services and go_router routes. Widgets call application commands; they do not solve schedules or determine conflict winners. Drift repositories implement domain-facing interfaces. Platform and cloud clients sit behind ports. The pure Dart engine consumes an immutable snapshot and returns proposals; it cannot mutate data. Domain code imports neither Flutter nor Supabase.

Keep required technologies: Flutter/Dart stable, Material 3, Riverpod, go_router, Drift/SQLite, Freezed/json_serializable, optional Supabase, flutter_secure_storage, local_auth, timezone and flutter_local_notifications. A manifest entry is not evidence of feature implementation. At implementation time record exact compatible versions, upstream maintenance/release evidence, licences, native minimum versions, transitive/native dependencies and why each dependency is needed. Do not silently retain end-of-life SQLite binaries or add broad plugin bundles for a narrow capability.

## Local write boundary

Every meaningful command executes in a local database transaction:

1. Validate typed input and current aggregate/version preconditions.
2. Write entities with stable UUIDs, increment versions and record timestamps.
3. Write the before/after change set and inverse operation for reversible actions.
4. If sync is enabled, append an outbox operation in the **same transaction**.
5. Commit; publish local state immediately. Remote work happens afterwards.

The outbox must not be appended after commit, because a crash could then leave an unqueued local change. SQLite is authoritative for the displayed plan. Optimistic feedback must not claim durability before the local transaction succeeds. Disk-full/database errors preserve form input and offer retry/export recovery; cloud errors do not interrupt local use.

Schema migration starts with version 1 and retains historical fixtures. Export the schema at each revision, test all supported upgrade paths with real rows, and test interrupted upgrades. Use SQL constraints for positive durations, allowed values and foreign keys where appropriate, plus domain validation. Never recover from a migration failure by deleting the user's database. Generated model files remain reproducible.

## Temporal and provider boundaries

Persist UTC instants plus the explicit temporal intent described in the domain document: IANA zone, wall-clock recurrence or all-day date range. Source/provider IDs and occurrence exceptions are separate from application UUIDs. Provider event data is authoritative for provider-owned timing; local notes/overlays do not silently become calendar writes.

On iOS, importing events requires EventKit full access: Apple has no read-only authorisation level. Calm Time's default is read-only **application behaviour**, despite that OS permission. Explain this before requesting access. [Apple EventKit documentation](https://developer.apple.com/documentation/eventkit/accessing-the-event-store)

On Android, direct reads and writes require their respective calendar permissions. Request read permission for import; request write permission only when the person chooses writes. [Android Calendar Provider documentation](https://developer.android.com/identity/providers/calendar-provider)

Cache only selected calendars and bounded occurrences. Revocation marks the cache unavailable/stale and stops reads/writes; policy must let the user remove the cache. Never turn a missing permission into “no commitments.” Calendar rows stay device-local by default and are excluded from cloud synchronisation unless a separate informed choice is made. Google/Microsoft adapters later implement the same port with separate OAuth scopes; no OAuth provider is claimed merely because its interface exists.

## Sync protocol proposal

Use an outbox operation UUID, device ID, payload schema, aggregate ID, base server version and new local version. Server commits assign an increasing sequence/version. `updatedAt` is display metadata, not conflict authority; device clock skew must not decide which work survives.

Each push is idempotent on owner plus operation UUID. The server transaction checks ownership and base version, applies an aggregate operation and records its acknowledgement atomically. Client acknowledgement/removal is transactional. Retrying after a lost response returns the same result without repeating the mutation.

Pull changes through a durable server cursor, including tombstones. Apply a batch and advance the cursor in one local transaction. Remote data updates the locally materialised database; it does not replace unsynced rows. Use exponential backoff with bounded jitter for transient failures; stop retrying permanent authorisation/schema errors and surface a corrective state. Resume on foreground/connectivity opportunities without promising permanent background execution.

| Conflict | Deterministic rule | User protection |
| --- | --- | --- |
| Independent task field edits from a common base | Three-way merge only fields proven independent | Preserve base/local/remote values and operation provenance |
| Same-field task edits | Preserve both in a conflict record; keep local working copy until resolved | No last-writer loss of title, notes or duration |
| Schedule changes | Treat a day revision as an aggregate; reject stale base and produce a reviewable reconciliation | Never silently combine two plans into overlaps or move commitments |
| Complete versus reopen | Explicit versioned state transitions; concurrent conflicting transitions need review | No unconditional “complete always wins” that erases explicit reopen/undo |
| Delete versus concurrent edit | Keep tombstone canonical remotely and preserve the edited payload as recoverable conflict data | No silent resurrection; restoring creates an explicit new version/generation |
| Provider changes | Update provider-owned fields from source, preserve distinct local metadata | A stale calendar write requires a new preview/confirmation |
| Preference conflicts | Deterministic server-version ordering for harmless scalar preferences; show changed values | Privacy/consent grants are device-scoped; disabling collection applies immediately and is not auto-re-enabled by remote preference merges |

Retain tombstones until all active devices acknowledge them. Expire dormant-device sync cursors under a documented retention policy; those devices must perform full reconciliation before uploading old operations. Server deletion/account epochs prevent stale clients recreating a deleted account's data. Full reconciliation preserves unsynced local creations in quarantine/exportable form; it must never discard them.

Linking an account requires a preview of local upload/merge scope. Local owner identity survives account changes. Signing out, pausing sync, deleting local data and deleting cloud account/data are distinct operations. Cloud deletion must revoke sessions/shares and prevent later outbox uploads; an offline request is labelled pending, not complete. Define hosted backup retention and deletion limits honestly before release.

## Undo across external systems

An accepted engine suggestion checks the proposal's base revision and calendar freshness inside the local transaction, applies its diff, records the decision and inverse, and updates the outbox together. Until confirmation, nothing changes.

One-tap undo applies the inverse atomically when affected entities still match the recorded after-state. Later intersecting edits require a compensating-change preview that preserves those edits. Keep both revision and undo action in history. Undo is a new versioned operation for sync, never deletion of the evidence that a revision happened.

Calendar writes cannot be atomic with SQLite. Use a separate provider-write state machine and idempotency mapping, with explicit failure/repair states. Before attempting an external inverse, check provider version and permission. Never claim that one local transaction guarantees rollback in an external calendar.

## Data protection and privacy defaults

Local-only mode starts no cloud, analytics, remote AI or crash-upload client. Store refresh tokens and key material in platform-backed secure storage; never place service-role credentials in the app. Biometric lock gates app access and sensitive previews but is not itself database encryption. Configure OS file protection, backup exclusions and app-switcher/lock-screen redaction.

Additional database encryption with a device-protected key is an open decision. Drift requires an explicitly configured encrypted SQLite implementation and key lifecycle; encryption must be tested in release binaries and cannot be inferred from using Drift. [Drift encryption documentation](https://drift.simonbinder.eu/platforms/encryption/)

Encryption at rest and TLS do not imply end-to-end encrypted sync. The proposed v1 Supabase model permits the operator to process synced plaintext; this limitation requires clear disclosure and approval before remote personal data is enabled. End-to-end encryption is an alternative with significant key-recovery, multi-device and sharing consequences; do not make that promise without implementing it.

Energy, calibration and recommendation histories are inspectable and deletable. Deletion invalidates derived caches and queues cloud erasure only if those histories were explicitly synced. Remove sensitive values from revisions/logs when the corresponding privacy deletion scope includes them. Ordinary soft deletion for sync is not proof of privacy erasure.

## Sharing design

Public links expose a deliberately created snapshot of selected blocks, availability or a routine. Hide titles, notes, provider details and owner identity by default. Show the exact payload before publishing. Source-plan edits do not silently broaden an existing snapshot.

Generate at least 256 bits of cryptographic token entropy; persist only a cryptographic digest for lookup. Use a verified HTTPS host and opaque bounded tokens. The public endpoint checks digest, expiry and revocation on every access, returns a minimal DTO and applies per-source/token rate limits, request-size limits and abuse monitoring. Do not allow public SELECT on owner tables or share enumeration. Keep tokens out of telemetry, referrer headers and crash breadcrumbs. Use no-store responses and no indexing; expiry cannot retract screenshots or already copied information.

Owner-only RLS policies cover every synced table and both reads and writes. Explicit grants and RLS are both necessary; privileged backend keys bypass RLS and stay server-side. Add allow/deny tests for anonymous users, owner, different owner, expired/revoked shares, forged owner IDs and public enumeration. [Supabase RLS documentation](https://supabase.com/docs/guides/database/postgres/row-level-security)

## Threat model

Assets: task/calendar content, personal routines, working patterns, energy/duration records, auth tokens, database/export files, revision history and public share capabilities. Boundaries: UI↔local services↔SQLite; app↔OS/providers/extensions; device↔Supabase; anonymous viewer↔sharing endpoint; builds/CI↔release stores. Adversaries include a lost-device finder, malicious share recipient, hostile authenticated tenant, abusive unauthenticated client, compromised dependency and operator error.

| Threat | Required mitigation | Verification / remaining exposure |
| --- | --- | --- |
| Lost unlocked device or sensitive lock-screen surface | App lock, short background relock, obscured switcher, generic notification/widget defaults, protected storage | Real-device lock/unlock and extension tests; rooted/compromised OS is outside guarantees |
| Token theft or cross-account access | Secure storage, explicit sign-out cleanup, least privilege, owner RLS and server checks | Adversarial RLS/session tests; service keys never shipped |
| Guessing/forwarding share URLs | High-entropy tokens, digest lookup, expiry/revocation, rate limiting and no enumeration | Guess/expired/revoked tests; possession of a valid forwarded link grants its snapshot access |
| Deep-link or imported-text injection | Strict scheme/host/path/length/type validation; render text as text; reject arbitrary redirects/SQL/commands | Fuzz malformed inputs and oversized payloads; no link-triggered writes |
| Sync replay/conflict/deletion resurrection | Idempotency, base versions, tombstones, account epochs and conflict preservation | Dropped acknowledgement, skewed clock, stale-device and concurrent-edit tests |
| Analytics/crash/log exfiltration | Allowlisted event schema; no titles/notes/calendar content/tokens; opt-in upload and redacted errors | Payload snapshot/redaction tests and SDK configuration review |
| Malicious dependency/build | Review native/transitive licences and permissions, lock versions, scan secrets/history, least-privilege CI and protected release secrets | Dependency inventory and reproducible CI; no secrets in build-time public configuration |
| Permission revocation/provider failure | Contextual permission, capability detection, stale indicators, cancellable operations | Denied/revoked/restricted tests; local planning remains available |
| Data leakage through exports/backups/history | Explicit export action, warn that a full export includes personal content, exclude tokens, avoid automatic clipboard writes, scoped deletion | Inspect full export and backup configuration; recipient controls exported files |
| Solver corruption or stale preview | Independent constraint validator, work conservation, base-version check, transactional inverse | Generated invariant tests and restart/undo tests; never apply an invalid fallback |
| Public endpoint denial of service | Bounded payloads, limits, quotas and operational alerts; no app-facing monetisation | Load/abuse tests and graceful unavailable state; remote availability is not guaranteed |

No production exposure is authorised by this threat model. Cloud readiness requires implemented controls and tests, not this document alone.
