# Changelog

## Unreleased

- Add date-scoped planning/history, shared Inbox, current-time text and injectable clocks.
- Add five reconciled starter templates with selected-block confirmation, duplicate/stale guards and durable undo.
- Validate and preview day imports; preserve original dates/dependencies and reject repeated or malformed imports atomically.
- Persist Quiet Focus countdown/count-up, pause/resume/restart, abandoned sessions and interruptions using Android monotonic time; require review when reboot invalidates time evidence.
- Link explicit task completion to measured focus time and reversible history; prevent deleted measurement snapshots being restored by undo.
- Migrate SQLite to v11 with a single-active-focus constraint and historical-record preservation.
- Update Android tooling/API 36, set the Dayweft label, restrict backups and reject release builds without upload signing.
- Remove unused generators/icons and the obsolete SQLite plugin; retain package lockfiles and add verification/release scripts.
- Record the 1.0 audit, remaining gaps and resumable roadmap. Native calendar, notifications, cloud sync, public sharing and store submission remain unfinished.

- Add task detail editing, validated predecessor links, reversible deletion/return to Inbox, drag placement and stale-editor protection across Today and Inbox.
- Expose block category/buffer editing and overnight end times; show before/after edit history and original/revised recovery times.
- Preserve confirmed capture fields inside blocks and retain/remap task constraints during local export/import.
- Detect nested overlaps, combined task demand, invalid identities/buffers and out-of-hours flexible work. Validate recovery alternatives and apply changes against stored identities and estimates.
- Make unavailable time affect recovery previews, run scheduling off the UI isolate and replace confidence percentages with evidence explanations.
- Migrate local task storage to schema v10; add SQLite/controller/gesture/accessibility and light/dark layout regression tests.
- Enforce separate 80% domain/application coverage gates in CI and build iOS simulators without signing; retain the Flutter-generated iOS 15/Swift Package Manager integration.

- Expand local onboarding with skippable preferences and opt-in samples; preserve personal tasks when removing samples.
- Preserve confirmed offline capture fields and support atomic brain-dump undo.
- Retain undo history, restore task placement after block deletion, and reject stale or invalid recovery application.
- Record genuine actual durations; show median/spread only with sufficient evidence and add per-record learning controls.
- Require explicit energy opt-in and exclude unverified legacy measurements from calibration.
- Document the proposed Calm Time architecture, verified implementation gaps and outstanding release gates.

## 0.1.0

- Created initial Dayweft planning documentation and Flutter monorepo scaffold.
