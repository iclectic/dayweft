# Dayweft Adaptive Engine

## Purpose

The Dayweft Adaptive Engine is a pure Dart scheduling package. It evaluates whether a plan still fits reality and generates explainable recovery alternatives while protecting user control.

## Inputs

- Planning day, timezone and locale calendar context.
- User availability windows, wake time, wind-down time and working hours.
- Fixed commitments, flexible blocks and optional blocks.
- Tasks with estimated duration, actual duration, deadline, priority, category, notes metadata, energy need, cognitive load, dependency list, split policy and minimum useful duration.
- Travel, preparation, transition and recovery buffers.
- User-defined breaks and contingency preferences.
- Disruption report.
- Estimation calibration factors where sufficient evidence exists.
- Energy planning setting and optional current energy check-in.

## Outputs

- Reality Check observations.
- Feasibility result with blocking constraints.
- Up to three alternatives: Protect Essentials, Balanced Reweave and Reduce Pressure.
- Per-alternative preview schedule.
- Change explanations.
- Protected commitments list.
- Deferred work list.
- Trade-offs.
- Confidence and uncertainty reasons.
- Reversible change set.

## Constraints

- Fixed commitments do not move unless the user explicitly approves.
- Flexible tasks move only within permitted windows.
- Optional work may be deferred when needed.
- Dependencies must remain topologically valid.
- Deadlines must be respected or clearly reported infeasible.
- Transitions, travel, preparation and recovery buffers must be reserved.
- Tasks are split only when permitted.
- Split fragments must meet minimum useful duration.
- User-defined breaks must remain present unless the user overrides.
- Original plan is preserved for comparison.
- Applied changes are recorded as reversible revision events.

## Invariants

- No negative-duration blocks.
- No unresolved overlaps in an accepted schedule.
- Fixed events never move without approval.
- Tasks never disappear during rescheduling.
- Changes are reversible.
- Dependencies remain valid.
- Minimum task durations are respected.
- Infeasible schedules are reported instead of hidden.
- Time-zone changes preserve event intent.
- The engine is deterministic for the same input.
- Explanations reference actual constraints that affected the result.
- Confidence is derived from constraints, slack and evidence, not from opaque model probability.

## Recovery Alternatives

Protect Essentials prioritises fixed commitments, high-priority tasks and deadlines. It defers optional work early and avoids aggressive splits.

Balanced Reweave minimises disruption while preserving reasonable transitions and keeping most planned work if feasible.

Reduce Pressure preserves commitments and recovery time, defers optional or lower-priority work more readily and favours lower utilisation.

## Learning Model

Phase 1 learning is deterministic statistics only:

- Estimate factor by category/time bucket after minimum sample threshold.
- Confidence interval or uncertainty band.
- Rejection/acceptance counts by suggestion type.
- User controls to exclude records and delete learning history.

No ML model is introduced until consented data volume and measurable scheduling improvement justify it.

## Testing Strategy

- Unit tests for each scheduling rule.
- Invariant tests for generated schedules.
- Property-based tests over random tasks, windows, deadlines and dependencies.
- Regression fixtures for DST, overnight shifts and timezone changes.
- Golden explanation fixtures so rationale stays stable and reviewable.
