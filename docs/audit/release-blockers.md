# Release blockers

Dayweft 1.0 is **not ready for submission**. Baseline: 26 October 2026, `33b5103`; this list reflects the 29 October local continuation. See the [verification record](verification-2026-10-29.md).

## Engineering work

- Complete hard permitted windows, persisted splits, recurrence/exceptions, full-device backups and the remaining Focus UI/hardware/notification lifecycle gates. Date-scoped plans, custom templates and durable Focus already have code and automated evidence.
- Implement native calendar import/reconciliation, notification scheduling/cancellation and external capture.
- Implement and security-test optional auth/sync/account deletion and real revocable public sharing.
- Complete functional settings, privacy deletion, themes, localisation and accessible layouts.
- Confirm Android identity, configure owner upload signing, finish permission/assets review and verify native 16 KB compatibility in release binaries. Missing signing now fails closed; debug release signing has been removed.
- Finish CI pin/scanner integration and complete quality evidence. Local reproducible verification, generation drift and real secret scanning are implemented/executed; they do not establish CI or release readiness.

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
