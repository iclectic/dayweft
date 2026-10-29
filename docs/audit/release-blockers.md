# Release blockers

Dayweft 1.0 is **not ready for submission**. Baseline: 26 October 2026, `33b5103`.

## Engineering work

- Complete local planning across dates, hard permitted windows, persisted splits, templates/recurrence, full backup/import and durable focus.
- Implement native calendar import/reconciliation, notification scheduling/cancellation and external capture.
- Implement and security-test optional auth/sync/account deletion and real revocable public sharing.
- Complete functional settings, privacy deletion, themes, localisation and accessible layouts.
- Replace debug release signing, review Android identity/SDK/permissions/backups, verify native 16 KB compatibility and release binaries.
- Add reproducible verification, real secret/advisory scanning, generation-drift checks and complete quality evidence.

## External inputs and validation

| Dependency | Exact owner action | Status |
| --- | --- | --- |
| Android identity | Confirm ownership/availability of existing provisional `app.dayweft.dayweft_mobile` or authorise final ID before Play registration | BLOCKED |
| Signing | Create/provide protected upload keystore/passwords outside git, choose Play App Signing; never send secrets in chat | BLOCKED |
| Supabase | Provide project/account/deployment access, production region and retention decisions after local implementation | BLOCKED for live verification |
| Sharing host | Provide verified HTTPS host and deploy secure endpoint | BLOCKED for public-browser verification |
| Policy/support | Approve privacy/terms and supply public privacy/support URLs and monitored contact | BLOCKED |
| Android hardware | Execute documented TalkBack, notifications, calendar, lock/reboot, background and release performance journeys on named devices | PENDING; no results fabricated |
| Play Console | Owner creates app, completes verification/declarations, uploads signed candidate and controls rollout | BLOCKED |
| Closed test | Recruit eligible testers and satisfy account-specific requirements | PENDING real participation/duration |

Official [Play target SDK requirements](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en) checked on 26 October 2026 specify API 36 for new phone applications/updates from 31 August 2026. Recheck at submission. Store/account approval is not implied by code or an AAB.

External dependencies do not prevent independently implementable local work. Track progress in [ROADMAP](../ROADMAP.md).
