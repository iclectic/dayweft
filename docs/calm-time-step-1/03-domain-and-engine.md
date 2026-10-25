# Initial domain model and Adaptive Day Engine

Status: proposed. Names describe responsibilities, not a final SQL schema or exported API.

## Initial entities and value objects

| Entity/value | Essential information | Relationships and rules |
| --- | --- | --- |
| LocalProfile / PlanningPreferences | Local owner UUID, working pattern, planning style, locale/zone/time format, optional wake/wind-down, energy toggle | An account is a later attachment, not the owner identity of all local records |
| PlanningDay | UUID, local date label, IANA zone, explicit start/end boundaries, baseline revision ID | May cross midnight; a shift day is not assumed to be 24 hours |
| AvailabilityWindow / BreakRule | Zoned working windows, allowed days, recurrence, protected break duration/window, transitions/recovery preferences | Supports multiple windows, night shifts and exceptions; preferences distinguish hard protection from soft preference |
| Task | UUID, title/notes, status, category/priority, estimated and remaining work, optional deadline/release time, flexibility, energy/load | Exists independently of a block; a task is never deleted because no slot fits |
| TaskDependency | Predecessor/successor UUID, finish-to-start relation | Directed acyclic graph in v1; reject cycles and missing required predecessors |
| TimeBlock | UUID, day, start/end, fixed/flexible/optional type, purpose, source, permitted window, buffer policy | Represents a reserved interval, not task identity; fixed is default for imported commitments |
| TaskAllocation | UUID, task/block IDs, allocated work minutes, ordering, optional fragment index | A task can have several allocations; sequential v1 allocations must fit usable block capacity |
| SplitPolicy / ScopeOption | Can split, minimum useful fragment, optional maximum fragments, user-approved shorter scope with separate remaining work | Shorter scope does not pretend the original work disappeared or finished |
| CalendarConnection / CalendarSource | Device/provider, local calendar key, visibility, permission capability, import freshness | Device credentials/provider identifiers do not become portable application IDs |
| CalendarOccurrence | Source, series identity, occurrence/exception identity, temporal intent, provider version, cached busy interval | Imported read model; recurrence exceptions and all-day semantics retained |
| Template / RoutineRule / Exception | Template blocks/task blueprints, recurrence, zone intent, date exclusions/overrides | Materialised tasks/blocks get stable new UUIDs; application key prevents accidental duplicates |
| Disruption | Type, occurred-at, amount/new work/energy/break information, affected IDs, user constraints | User input describes reality; it is not implicit permission to move every fixed event |
| RealityObservation | Reason code, affected IDs/intervals, severity, evidence and corrective choices | Facts or labelled heuristics, never a productivity score |
| ProposalSet / RecoveryAlternative | Snapshot revision/hash, engine/policy versions, profile, typed changes, trade-offs, evidence strength, status | Zero to three distinct validated alternatives; a proposal does not mutate the plan |
| RecommendationDecision | Proposal/alternative IDs, accepted/rejected/undone, timestamp, optional reason code | Local learning evidence, separate from analytics; deleting history removes derived effects |
| PlanRevision / RevisionChange | Stable revision ID, base/result version, command ID, actor, before/after values, inverse change set | Immutable logical history; privacy deletion may redact content while retaining minimal integrity metadata |
| FocusSession / Interruption | Task, mode, start/end, pause segments, elapsed work, outcome, interruption type/duration | One active session per device in v1; expiry/abandon is not task completion |
| DurationObservation | Estimate-at-start, actual active minutes, category, local start time/day, interruptions, split flags, provenance, exclusion | Immutable estimate baseline; clock anomalies flagged; deletion invalidates calibration caches |
| CalibrationSummary | Cohort definition, method version, sample size, estimate factor, uncertainty/spread, last calculation | Derived and reproducible; no conclusion below evidence threshold |
| EnergyCheckIn | Optional low/steady/high, timestamp, consent/feature state | Not medical data interpretation; not used when disabled; complete deletion supported |
| ShareSnapshot / ShareGrant | Selected minimised blocks or availability/template, expiry, revocation, token digest | Separate from owner tables; no live leakage when the original plan changes |
| SyncOperation / ConflictRecord | Operation UUID, entity/aggregate, base server version, payload schema, retry state, conflicting versions | Infrastructure records; not imported by the engine |

All mutable persisted aggregates have stable UUIDs, schema/model versions, created/updated metadata and soft-deletion state where appropriate. Wall-clock `updatedAt` is informational, not an ordering authority. Domain models must not import Flutter, Riverpod, Supabase, SQLite or platform APIs.

## Time and work semantics

Store elapsed durations as integer units and schedule intervals as half-open `[start, end)` instants. Adjacent intervals may touch. Require strictly positive duration for blocks/fragments and nonnegative remaining work. Milestones, if introduced, are a separate type, not zero-length blocks.

Represent **instant-bound**, **zoned wall-clock** and **all-day date** intent separately. A meeting at an absolute instant is displayed in a new zone without changing its instant. A routine at 09:00 Europe/London retains that zone rule; a local floating routine follows the selected local zone. All-day events remain date ranges. Ambiguous autumn-fold times require an offset choice; nonexistent spring-gap times require a visible adjustment before confirmation. Never add 24 hours to derive the next local day.

The application materialises bounded zoned windows and calendar instances before invoking the engine. The pure Dart engine receives validated instants plus intent metadata; it does not infer time zones from device globals. DST and zone conversion require separate adapter tests as well as engine tests.

Task work and block length differ. Buffers reduce usable capacity. Splitting redistributes the same remaining work. Deferral preserves remaining work and a visible unscheduled/deferred outcome. Shortening requires a pre-authorised scope alternative or explicit confirmation describing what remains; it never simply reduces an estimate to make a schedule look feasible.

## Pure Dart engine boundary

Location: `packages/adaptive_day_engine`. Inputs are immutable, versioned planning snapshots: current time, day horizon, tasks/allocations, immutable commitments, windows, constraints, disruptions, optional permitted energy data and evidence summaries. No network, database, UI, ambient clock or random tie-breaker is allowed.

Outputs are typed Reality Check observations, a search status and up to three alternatives. Each alternative contains assignments, explicit unscheduled/deferred work, constraint validation, typed change reasons and a trade-off summary. Store a canonical input hash, engine version and policy version to reproduce a proposal. UI localisation maps reason codes to text; explanations never depend on a cloud language model.

Application services own snapshot creation, persistence, confirmation, stale-result checks, learning and undo. Riverpod injects these services. The engine itself cannot write a schedule or provider event.

## Constraints

| Constraint | Hard rule | Soft preference / corrective choice |
| --- | --- | --- |
| Immutable commitments | Fixed, imported, completed and elapsed portions do not move; a specific override must name the event and permitted change | Offer “ask to change this commitment”; do not put an unauthorised move into an applicable alternative |
| Exclusive time | No simultaneous exclusive work/commitments or their required buffers | Existing overlapping fixed events yield an infeasible observation, not a fabricated valid plan |
| Availability | Flexible work stays inside user-permitted intervals, release times and the planning horizon | Prefer original position; extending a day or crossing wind-down needs explicit consent |
| Deadlines | All required remaining work and dependencies finish by a hard deadline | A user may explicitly renegotiate it; optional status does not bypass a hard deadline |
| Dependencies | Predecessor completes before successor work begins; actual completions honoured | Prefer minimal fragmentation and preserve useful sequence |
| Capacity | Sequential allocations plus task buffers fit block capacity; do not double-count a reservation and its child work as separate occupancy | Keep checklist items without duration clearly distinct from allocated work |
| Splitting | Only allowed tasks split; each fragment meets minimum useful duration, fragment count and permitted windows; no tiny leftover remainder | Penalise extra fragments and transitions |
| Scope | Do not reduce work unless a user-approved scope variant permits it | Prefer preserving work; show remainder or consciously dropped scope |
| Buffers | Protect declared travel/transition/recovery intervals; no overlap with exclusive work | Shared adjacent buffers may be coalesced only under an explicit policy, never counted twice or silently removed |
| Breaks | Required breaks occupy a valid interval of minimum length within their permitted window | Suggested additional rest is a preference; cannot erase protected breaks to rescue feasibility |
| Optional/deferred work | All unscheduled work is returned with identity, remainder and reason | Prefer deferring optional work before essentials; no automatic new-day assignment beyond the approved horizon |
| Energy and load | With energy disabled, energy inputs have no effect; user-defined hard limits remain hard | When enabled, prefer a suitable load/energy match and avoid demanding clusters; explain the effect |
| Now and disruptions | Completed/past time is frozen; in-progress work is anchored with explicit remaining duration | Running late changes available time; meeting overrun can add a local busy overlay without writing the source calendar |
| Imported uncertainty | Denied/stale calendar data cannot support a claim that all commitments are known | Mark the result conditional on known commitments; invite refresh/manual busy entry |

Energy/load cluster warnings and utilisation warnings use disclosed thresholds, not medical interpretations. Proposed starting utilisation warning: planned exclusive minutes plus buffers exceed 85% of available planning time after required breaks. Treat this as an editable heuristic, show numerator/denominator and gaps, and never call it proof of infeasibility. Hard infeasibility depends on constraints, not that percentage.

Reality Check also reports overlap, transition shortfall, missing required breaks, impossible deadline combinations and excessive demanding-work clusters. Missing task estimates lead to “duration unknown” observations, not silently zero-duration work. Contradictory break/working-window rules and dependency cycles are invalid inputs with repair guidance.

## Deterministic solver v1

1. Canonicalise and validate input. Freeze completed/elapsed work and fixed commitments; materialise occupied intervals including buffers. Detect directly contradictory hard constraints and invalid graphs.
2. Compute gaps within permitted windows. Use a one-minute scheduling grid for flexible work, anchored relative to the horizon, while retaining exact external event boundaries. Round candidate work/buffers conservatively; never move imported events to the grid. Feasibility is defined relative to this declared grid.
3. Order candidates deterministically by essential status, hard deadline, dependency readiness, permitted-window tightness, priority, original order and stable UUID. Enumerate permitted scope/split/defer decisions using deterministic bounded branch-and-bound with gap pruning.
4. Run three policy profiles with different soft objectives. Use lexicographic, versioned criteria rather than an unexplained scalar productivity score. Stable tie-breaking makes repeated inputs yield the same output, including under shuffled source collections.
5. Independently validate every complete candidate against all hard constraints and work accounting. Deduplicate equivalent alternatives. Return fewer than three when only fewer are valid; never invent an alternative to fill the UI.
6. Bound computation by a deterministic explored-state budget. Return `invalidInput`, `feasible`, `provenInfeasible` or `searchLimitReached` as appropriate. Only exhaustive search/proof may establish infeasibility; a timeout/budget limit is not proof. A search-limited result may contain independently validated candidates, clearly without an optimality claim.

The application runs solving off the UI isolate. Initial performance targets and state budget must be measured against representative workloads in Phase 0, before the algorithm contract is frozen. If bounded search cannot meet them, review the solver approach explicitly rather than quietly dropping constraints.

| Alternative | Lexicographic preference after hard validity | What the user sees |
| --- | --- | --- |
| Protect essentials | Preserve essential/deadline work, minimise lost permitted scope, then minimise displacement | Optional work deferred before essential work; breaks still protected |
| Balanced recovery | Preserve essentials, preserve work volume, avoid long demanding clusters, then minimise displacement/fragmentation | Balanced task movement and recovery, with each sacrifice named |
| Reduce pressure | Preserve hard commitments/deadlines, use user-permitted extra recovery, then reduce optional load | More optional work deferred and more slack; cannot relax hard deadlines |

Confidence means **evidence strength**, not the probability that the user will succeed. Use low/moderate/high labels backed by known estimates, evidence counts/spread, calendar freshness and unresolved assumptions. State a rule such as “low: three task durations unknown”; do not invent percentages. Constraint validity and evidence strength are displayed separately.

Example: at 10:00 a meeting extends to 10:30; another fixed event begins at 11:00; travel needs 15 minutes; a 40-minute task has 20-minute minimum fragments. Only 15 minutes remain before travel, so placing a fragment there is invalid. An alternative moves the task after the fixed event, or defers it if permitted. If its hard deadline is 11:00, report the conflict and ask which constraint may change. The engine must not shorten the task or travel time to make it fit.

## Estimation calibration and recommendation learning

Record estimate-at-start versus active work duration, interruption periods, category, local time/day and split status. Manual actual durations are labelled as manual. Do not treat missed/abandoned work or unmeasured interruptions as clean completed observations. Retain estimates as originally made so later recalibration cannot rewrite history.

Proposed initial method: median of valid actual/estimate ratios with a visible empirical spread and sample size. Require at least 10 eligible completed observations for a category adjustment; require at least 20 in any finer time/day/split cohort before exposing that breakdown. These are conservative product thresholds requiring approval and later validation, not statistical guarantees. Avoid combining sparse dimensions into misleading precision. Fall back to unadjusted user estimates and an insufficient-data message.

Suggested estimates remain editable and labelled, for example “category median ×1.2, n=14, middle half ×0.9–1.6.” Do not call the spread a confidence interval. Deleting/excluding observations recomputes all affected summaries. No category title or task text is required by the algorithm.

Accepted/rejected/undone alternatives record local decisions. A rejection without a reason does not imply that every constituent change was disliked. Use explicit reason codes, repeated evidence and minimum sample sizes for bounded tie-break preferences among already valid alternatives. Log which policy adjustment influenced a recommendation. Learned preferences never weaken hard constraints, enable energy use or bypass confirmation. Version/reset all learned state; rejected and accepted decisions remain inspectable and deletable.

## Required invariants and tests

| Invariant | Test obligation |
| --- | --- |
| No negative/zero-duration scheduled blocks | Boundary tests for zero, negative, overflow and invalid end/start; fuzz generated intervals |
| Fixed events do not move without scoped approval | Compare exact IDs/instants and approval scope across every alternative and replay |
| Valid alternatives have no unresolved exclusive overlap | Independent interval/buffer validator; adjacent boundaries and imported overlaps |
| No silently lost task/work | Input remaining work equals allocated + explicitly deferred/unscheduled + explicitly approved removed scope; identities retained |
| Constraints remain valid | Per-constraint tests, pairwise interactions, dependency chains/cycles, deadlines, windows, breaks and split remainders |
| Deterministic results | Same canonical snapshot/policy produces byte-equivalent logical output; shuffle input order |
| No mutation before confirmation | Engine purity plus application test showing reject/cancel leaves the schedule unchanged |
| Applied changes reversible | Apply/invert restores logical before-state atomically; crash/restart and subsequent-edit conflicts covered |
| Stale proposals cannot overwrite edits | Revision and calendar-freshness precondition race tests |
| Time intent preserved | Europe/London spring gap/autumn fold, America/New_York transitions, Asia/Kolkata offset, night shifts, all-day and travel cases |
| Infeasible plans not corrupted | Contradictory fixed/deadline/break cases return named conflicts and retain all work; budget exhaustion has distinct status |
| Privacy toggles effective | Energy-disabled output invariant under energy-data changes; history deletion removes learned effects |

Use a separate small exhaustive oracle to validate generated small scheduling problems. Add seeded property-based cases for work conservation, invariant preservation and apply/undo round trips, including reproducible failing seeds. Do not merely test the solver with its own internal validator. Domain/application coverage must be at least 80%, with the constraints explicitly exercised even where line coverage already passes.
