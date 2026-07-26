# Dayweft Privacy And Security Threat Model

## Privacy Position

Dayweft is local-first. Local planning works without an account. Cloud sync, sharing, analytics and AI are optional. Users can export data, delete learning history and delete cloud accounts.

## Data Classification

Highly sensitive:

- Task titles and notes.
- Calendar event titles and locations.
- Focus-session content.
- Brain dumps.
- Shared plan details.

Sensitive metadata:

- Time blocks, categories, deadlines, estimates, actuals, energy check-ins, interruptions, recurrence and calendar source IDs.

Privacy-safe analytics only:

- Consent state, event type, feature area, counts, timings, coarse platform and non-content error codes.

## Analytics Rules

Analytics must be opt-in. Never collect task titles, notes, calendar titles, focus-session content or personal schedule descriptions.

Allowed event catalogue:

- onboarding completed;
- first plan created;
- block created;
- Quiet Focus session completed;
- Reality Check completed;
- Reweave My Day opened;
- suggestion displayed;
- suggestion accepted;
- suggestion rejected;
- suggestion undone;
- calendar connected;
- template applied.

## Threats And Controls

| Threat | Control |
| --- | --- |
| Device loss | Optional biometric app lock, OS storage protections and secure storage for credentials. |
| Secret leakage | No committed secrets, environment-specific config, CI secret scanning. |
| Overbroad logs | Structured logs without personal content. |
| Sync conflict data loss | Append-only operation queue, versions, tombstones and conflict records. |
| Public link enumeration | High-entropy token, token hashing at rest, rate limits, expiry and revocation. |
| Oversharing private details | Availability-only sharing default; explicit selection for task details. |
| Calendar permission abuse | Read-only import by default, per-calendar controls and revoked-permission recovery. |
| AI data exposure | Disabled by default, explicit consent, preview payloads and local deterministic fallback. |
| Account deletion gaps | Cloud deletion workflow, local unlinking and deletion receipt where provider allows. |
| Inaccurate health claims | No diagnostic labels, no burnout-risk claims, observations only. |

## Security Requirements

- Supabase RLS for all cloud tables.
- Public endpoints separated from owner tables through least-detail views or functions.
- Rate limits on sharing endpoints.
- App transport over TLS only.
- Secure storage for tokens.
- No personal data in crash reports.
- Privacy manifests and permission descriptions for app stores.
- Open-source licence disclosure.
