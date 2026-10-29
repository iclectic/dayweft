# Android manual verification gate

All items below are pending actual device/emulator evidence. Automated test results are in the [27 October checkpoint](../audit/verification-2026-10-27.md).

Record build version/commit, device model, OS/API, timezone, accessibility settings, steps, observed result and evidence path for each exercise. Do not mark a step passed because a widget or repository test passed.

- Fresh install, all onboarding skips, safe sample removal and an offline first plan.
- Create/edit/move/delete tasks and blocks on two dates; restart and verify persistence; undo the correct date's change.
- Preview a template around existing appointments, select a subset, apply/undo, and attempt repeated application.
- Export/import a day, review counts/date, reject malformed/repeated files and undo the batch. Full-device backup is unfinished.
- Start countdown/count-up sessions, pause/resume, record interruptions, restart/abandon and confirm measured task completion/undo.
- Lock screen, background, kill the process, change wall time/timezone and reboot during Focus. Same-boot elapsed time must remain correct; changed references require review without invented time. No notification delivery is currently promised.
- TalkBack, keyboard/switch paths, 200% text, narrow/landscape layout, dark mode and non-drag movement.
- Profile a release/profile build on representative hardware; measure startup, scrolling, schedule recomputation, memory and battery. No device performance figures exist yet.
- Verify backup exclusions, merged components/permissions, native 16 KB alignment and release signer identity.
- Test calendar import, reminders, account/sync/deletion, public sharing and biometric controls only after real implementations exist; these acceptance gates remain open.

Owner prerequisites: confirm application ID, provide a protected upload key, privacy/support URLs and reviewed disclosures, configure/deploy optional services and use Play Console to create internal/closed test tracks. No real tester participation, production-access approval or publication is claimed.
