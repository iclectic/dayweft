# Architecture review

Baseline: `33b5103`, 26 October 2026.

Retain Flutter/Riverpod/go_router/Drift and the independently tested Dart engine. Widget commands already travel through a Riverpod controller and SQLite transactions. Engine previews are immutable and isolated from persistence. These boundaries are suitable for incremental completion.

## Findings and implementation direction

| Area | Finding | Direction and acceptance |
| --- | --- | --- |
| Persistence | One large repository owns unrelated domains | Extract bounded responsibilities as functionality changes; preserve existing API where practical and test real SQLite |
| Time/date | `DateTime.now()` and implicit Today are spread through commands | Inject a clock and make selected-day context explicit; civil date navigation uses constructors, not 24-hour arithmetic; stale day actions reject |
| Transactions | Revision preconditions protect many planning writes | Keep validation/write/revision atomic; add concurrent/stale tests to new commands |
| Engine | Conservative reflow, fixed-event protection, no persisted split allocations | Extend domain allocation model before enabling splits; independently test hard constraints and no-loss invariants |
| Templates | Starter lists mixed into repository, unchecked additive inserts | Separate preview model; reconcile around existing reservations, select blocks, prevent duplicates, revalidate version at apply |
| Import/export | Single-day JSON merge; not full backup, no strict envelope | Validate before writing, show preview, preserve dependencies, version the format; complete all-day/history backup remains required |
| Focus | Foreground widget is the only active state | Persistent state machine with elapsed references; native monotonic/reboot handling behind a platform port; no fabricated elapsed time |
| Platform | Dependencies are declared but not integrated | Implement permission/capability adapters and real workflows; report unsupported/denied states honestly |
| Sync | Queue table alone has no operational meaning | Atomic outbox, server versions, idempotency, tombstones, conflicts and RLS tests before opt-in upload |
| Sharing | UUID text is called a token hash; no endpoint | Remove misleading production surface; build minimal snapshots and cryptographic digest lookup before hosted verification |
| Privacy | No analytics SDK initialisation; SQLite is unencrypted | Preserve local-only default; describe OS storage accurately; decide complete deletion, backup and app-lock scope explicitly |
| UI | Material 3 tokens exist, several screens are monolithic | Extract reusable workflows and date controls; add large-text/error regression tests before visual refinements |

No microservices, blanket repository rewrite, generated API framework or cloud requirement is introduced. Native calendar/notifications and cloud adapters remain independent of the deterministic engine.
