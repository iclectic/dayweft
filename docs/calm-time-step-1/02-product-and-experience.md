# Product direction, information architecture and accessibility

Status: proposed. This is a Step 1 direction, not an approved Step 2 specification.

## Product contract

Calm Time helps people keep a feasible day when work overruns, commitments change or capacity changes. It supports disrupted knowledge work, study, freelance work, shifts, caring and mixed responsibilities without treating any working pattern as the default norm.

The differentiating loop is: **plan → observe reality → explain a mismatch → preview alternatives → confirm → learn from the outcome**. Schedule feasibility, estimation evidence and protected recovery are real domain capabilities. CRUD, a generic chatbot and cosmetic scores do not constitute this loop.

Local use requires no account, network, analytics or energy check-in. No advertising, personal-data sales, subscriptions, purchases, donations or premium restrictions are included. Cloud service availability can limit a remote action, but must not disable local planning. No medical, diagnostic or therapeutic claims are permitted.

## Mobile information architecture

Use four persistent destinations, with a platform-appropriate Material 3 navigation bar. On wider layouts it can become a rail without changing the conceptual structure.

| Destination | Primary content | Secondary surfaces |
| --- | --- | --- |
| Today | Selected planning day's timeline, date strip, current-time marker, capture and My day changed | Block/task editor, Reality Check, original/revised comparison, revision history, calendar visibility, share selection |
| Inbox | Unscheduled tasks and rapid capture | Brain dump, parsed-value review, voice capture, schedule task, filters |
| Routines | Starter and personal templates | Template editor, recurrence/exceptions, reconcile preview and apply |
| Insights | Weekly reflection and evidence-based observations | Calibration records, plan/reality, deferrals, interruptions, recovery time, recommendation acceptance and export |

Settings is available from the app toolbar. It contains planning preferences, calendars, notification controls, privacy/data, optional account/sync, accessibility/appearance, AI controls, support and licences. Calendar events remain visible on Today with source labels; a separate calendar tab is unnecessary for version 1.

Focus is a full-screen task/session destination, opened from a task or block. Leaving Focus preserves the session and shows a compact return control. It does not occupy a permanent tab. My day changed is an action that opens a disruption flow, not a fifth destination.

Conceptual routes, to be finalised in Step 2:

- `/today/:localDate`, `/blocks/:uuid`, `/tasks/:uuid`, `/history/:revisionId`.
- `/inbox`, `/capture/review`, `/routines`, `/routines/:uuid/preview`.
- `/focus/:sessionId`, `/recovery/:requestId`, `/insights`, `/settings`.
- A separate verified HTTPS host for `/s/:token`, serving a minimal read-only shared snapshot; opening the app never imports or applies it automatically.

Dates and identifiers are validated at the route boundary. Locked-app and account callbacks pass through explicit guards. A link never carries database queries, arbitrary redirects or task content as executable instructions.

## Principal journeys and acceptance direction

| Journey | Interaction | Required outcome |
| --- | --- | --- |
| First launch | Explain local storage/optional cloud, then working pattern, wake/wind-down, calendar preferences and planning style | Skip each step or all; no permission prompts; conservative editable defaults, no inferred health information |
| Sample day | Offer optional labelled sample content | Remove only sample-owned records; preserve user-created edits/work and allow undo of removal |
| Capture | Type a task or multiple lines; optionally use voice or share sheet | Save a local draft promptly; preview inferred date/time/duration/priority/energy/category before structured commitment |
| Build a day | Add/edit blocks and place tasks; use advanced constraints only when needed | Local commit and history; accessible alternatives to drag, resize and reorder |
| Reality Check | Review concrete observations such as overlapping commitments or insufficient transition | Show affected intervals and choices; no fabricated productivity score or automatic repair |
| Recovery | Choose Running late, New urgent task, Meeting overran, Energy changed, Need a break, Missed part of the day or Custom | Review up to three feasible alternatives with change-by-change explanations; cancel leaves the plan intact |
| Apply recovery | Compare original/revised, then confirm | Atomic version-checked revision; no hidden provider write; durable one-tap undo for the unchanged revision |
| Focus | Start count-up/countdown, pause/resume, log interruptions, complete or abandon | Accurate recoverable elapsed time and explicit task outcome; timer expiry does not mark work complete |
| Apply routine | Select date/recurrence and preview reconciliation | Existing commitments remain; exceptions survive; duplicate application is detected; confirm and undo |
| Connect calendar | Explain scope at the point of use, request permission, choose calendars | Read import by default, fixed/source-labelled events, usable denied/revoked/offline states |
| Leave cloud | Pause sync, sign out or delete account using distinct actions | Explain what stays locally; pending local work is preserved; remote deletion status remains visible |

Voice must not be advertised as offline speech recognition on unsupported devices. Prefer available on-device recognition, with a text fallback and clear availability. Server transcription, if ever offered, requires separate consent before recording/uploading. Raw audio is not retained by default. Share-sheet capture queues local text through a narrow native entry point and presents confirmation; locked mode does not expose existing content.

The local parser is a bounded grammar, initially English, with explicit locale/time-zone input. For example, “Read chapter 3 tomorrow around 2pm for 30m high priority #study” produces editable chips. “Around” becomes a proposed window, not a fixed appointment. Unrecognised or ambiguous text stays in the title/draft; no invented date, energy or duration. Shortcuts never bypass parsed-value review.

## Timeline and scheduling UX

The timeline uses a time rail, typographic block headers and restrained separators. It does not place every row inside a card. Fixed commitments carry a lock/source icon and text, flexible work a move label, optional work an optional label. Buffers are quieter intervals with readable purpose. Empty time is allowed and does not imply failure.

Use proportional time spacing only while it remains legible. A minimum row size and an accessible agenda representation take precedence for short events and large text; the visual length must not be the only duration cue. Announce start/end, duration, type, completion and source. Overlaps are visible as conflicts rather than hidden by drawing order.

Recovery is a dedicated comparison surface, not a transient toast. Each alternative shows preserved essentials, moved/split/shortened/deferred work, protected recovery, remaining unallocated work, trade-offs and evidence strength. Individual changes can be inspected. “Keep my plan” and rejection are ordinary outcomes. An inability to find a valid plan is described plainly with corrective choices.

Undo remains available in history after a snackbar disappears. If later edits touch the same work, the user sees a compensating-change preview instead of losing those edits. Original versus revised views use labelled positions and a list of changes so colour is unnecessary.

## Proposed original visual system

Direction: warm paper-like neutrals, deep ink, a distinctive muted teal adaptive accent, clear typography and selective surfaces. These are draft tokens for prototyping, not contrast-verified production values.

| Token family | Initial direction | Verification before approval of visual specification |
| --- | --- | --- |
| Colours | Light canvas `#F7F4EE`, surface `#FFFCF7`, ink `#242925`, adaptive teal `#006B61`; dark canvas `#151A18`, surface `#202823`, ink `#F0F2EA`, teal `#78D8C6` | Measure every text/control/state pairing in both themes; use dedicated on-accent tokens |
| Typography | Platform system fonts; body 16, label 14, section 20, page 28 logical pixels as starting sizes | Support nonlinear system scaling; no fixed text heights; no font download dependency |
| Spacing | 4, 8, 12, 16, 24, 32, 48 | Maintain touch target padding independently of visual icon size |
| Radii | 8 for small controls, 16 for sheets/surfaces, full radius for sparse chips | Avoid nested rounded containers everywhere |
| Elevation | 0 for ordinary content, restrained 1–2 for sticky controls and modal hierarchy | Clear boundaries in dark/high-contrast conditions without relying on shadow |
| Motion | Approximately 120 ms feedback, 180 ms state transition, 240 ms sheet | Respect reduced motion; no mandatory spatial animation |
| Semantic status | Fixed, flexible, optional, conflict, pending, stale, complete, deferred | Icon/text plus colour; distinguish pending sync from a task failure |

Use native-feeling back behaviour, sheets, time pickers, text selection, haptics and safe-area/keyboard handling. Destructive actions provide undo or a clear confirmation appropriate to their consequences. Haptics and ambient audio are optional; ambient audio, if included, is licensed and bundled for offline use.

## Accessibility plan

Target applicable WCAG 2.2 AA criteria as a design/testing baseline, alongside native platform expectations. This is a target, not a compliance claim. WCAG explicitly calls for alternatives to dragging; Calm Time will provide buttons/forms for every timeline manipulation. [W3C guidance](https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/)

| Area | Product requirement | Acceptance evidence |
| --- | --- | --- |
| Screen readers | Structured headings, block/task semantics, labelled controls, meaningful selected/disabled/error state; no duplicate announcements | VoiceOver and TalkBack complete onboarding, capture, edit, recover, focus and undo on devices |
| Ordering | Chronological semantic order even when visuals overlap; restore focus after sheets/navigation; no focus hidden under sticky UI | Semantics-tree checks plus manual traversal |
| Motor access | At least 48×48 logical-pixel targets in Flutter, satisfying the product's 44×44-point floor; separated controls | Automated target-size checks and device review |
| Drag alternatives | Move to block/time/day, Move earlier/later, Edit start/end/duration, keyboard actions | Complete the same task with touch buttons, keyboard and switch access |
| Text/display scaling | Follow system scaling, including large accessibility sizes; reflow timeline into agenda if necessary | Small phones at 200% text and maximum supported system setting; no clipped essential content |
| Contrast | Normal text ≥4.5:1; large text ≥3:1; meaningful control boundaries/state graphics ≥3:1 | Token-pair measurements in both themes; grayscale/colour-vision checks |
| Non-colour meaning | Labels/icons for conflicts, type, changes and sync; no colour-only chart legends | Screen-reader and grayscale review |
| Reduced motion | Respect system preference and user override that can reduce further; replace motion with instant/fade state changes | Tests with animations disabled; no information available only through movement |
| Notifications/timers | No announcement every second; announce meaningful milestones; sounds/haptics optional | Screen-reader focus remains usable during a session |
| Errors | Inline field association, actionable copy, preserved input; no time-limited mandatory decision | Denied permission, invalid parser input and stale suggestion journeys |
| Localisation/RTL | ARB-backed strings, plurals, directional padding, locale dates/week start, 12/24-hour override | Pseudolocalisation, RTL fixture and long translations; times remain unambiguous |
| Cognitive load | Progressive detail, plain-language changes, persistent undo/history and no pressure mechanics | Usability review of disrupted-day and recovery flows |

Flutter recommends testing real screen readers, large scaling, contrast and touch targets; automated checks alone are insufficient. [Flutter accessibility guidance](https://docs.flutter.dev/ui/accessibility)

Every slice must include an empty state, permission-denied state where applicable, a recoverable error state and offline behaviour. Loading cannot block access to already available local content. Cloud connection status is quiet but accessible. No disabled placeholder button may imply that an unfinished feature works.
