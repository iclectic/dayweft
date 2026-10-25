# Calm Time — Step 1 review

**A day that adapts with you.**

Date: 24 October 2026. Status: **proposed; approval pending; reference-source verification blocked**.

This is the first-assignment decision pack. It proposes the Flutter product direction and does not assert that the existing Dayweft application meets the full requirements. The user subsequently authorised continuing unfinished implementation. That work is tracked in the [implementation ledger](../implementation-status.md); proposals here are not automatically treated as approved redesigns.

## Recommendation

Build around three capabilities: a trustworthy local plan, a deterministic recovery engine, and personal duration calibration with visible evidence. The engine proposes changes to flexible work around commitments and protected recovery time. A user confirms every change; accepted changes have a durable undo record. Cloud accounts, energy information and analytics are optional. All user-facing features remain free; there is no monetisation.

Use four primary destinations: **Today, Inbox, Routines and Insights**. Put Focus in the context of a task or block, and expose **My day changed** from Today. Settings, calendar connections and privacy controls sit outside primary navigation.

Use Drift/SQLite as the source of truth, a separate pure Dart engine, and a transactional revision/outbox boundary. Synchronise versioned operations rather than replacing whole days. Keep imported calendar data local by default. Release cloud and public sharing only after isolation, conflict and abuse tests pass.

## Documents

| Document | Requested deliverables |
| --- | --- |
| [Reference audit](01-reference-audit.md) | 1. Concise product audit; 2. Retain/Redesign/Replace/Remove matrix; retained behaviours, rejected web assumptions and evidence limits |
| [Product and experience](02-product-and-experience.md) | 3. Flutter information architecture; 7. accessibility plan; visual direction and principal journeys |
| [Domain and adaptive engine](03-domain-and-engine.md) | 4. Initial entities; 5. constraints, invariants, recovery, estimation and test scenarios |
| [Data, sync and threat model](04-data-sync-and-threat-model.md) | 6. Offline-first storage and sync; 8. security/privacy threat model; platform boundaries |
| [Phases, risks and approval](05-phases-risks-and-approval.md) | 9. Phased plan and acceptance criteria; 10. decisions requiring approval; risk register and unresolved questions |

## Evidence qualification

The requested [reference repository](https://github.com/iclectic/calm-time) returned HTTP 404 through the GitHub connector and a direct GitHub API request. Repository metadata, the default-branch tree and a named source file were unavailable. Search did not recover a verifiable source snapshot. This does **not** establish whether the repository is private, renamed, deleted or inaccessible to the current credentials.

The workspace contains a [historical reference audit](../reference-audit.md), committed in `a25319b9ca3032c130a76ff46f509b550bd8633e` on 26 July 2026. It is secondary evidence, not a substitute for inspecting source. The reference audit in this pack labels its claims accordingly. No current reference commit, runtime behaviour, licence or security defect has been verified. An accessible source snapshot with a commit identity is needed to finish that portion of Step 1.

The architecture is an original proposal grounded in the supplied brief and the official platform references linked in the documents. Package versions are deliberately unpinned in this proposal. No dependency additions or scaffolding were needed for the document pack. Subsequent code changes and checks are recorded separately in the implementation ledger; no commit, push or deployment has been performed in this assignment.

## Approval boundary

Review the [approval decisions](05-phases-risks-and-approval.md#decisions-requiring-approval). The continuation request authorises implementation of missing requirements, but does not silently choose consequential alternatives such as an E2EE cloud model or a new repository. Continue independent local work while resolving those choices. Verify the reference source or obtain an explicit waiver before claiming the fresh source audit complete.
