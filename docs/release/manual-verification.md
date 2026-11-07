# Android manual verification gate

Full user journeys below remain pending unless explicitly scoped in the dated evidence. Automated results and the limited native Android 36 Focus probes are in the [29 October checkpoint](../audit/verification-2026-10-29.md).

Record build version/commit, device model, OS/API, timezone, accessibility settings, steps, observed result and evidence path for each exercise. Do not mark a step passed because a widget or repository test passed.

- Fresh install, all onboarding skips, safe sample removal and an offline first plan.
- Create/edit/move/delete tasks and blocks on two dates; restart and verify persistence; undo the correct date's change.
- Preview a template around existing appointments, select a subset, apply/undo, and attempt repeated application.
- Create/edit/duplicate a custom template, save a reviewed day, confirm/cancel deletion and undo it after closing the library. Verify task details/notes are excluded and an old preview rejects a later template edit.
- Export/import a day, review counts/date, reject malformed/repeated files and undo the batch. Full-device backup is unfinished.
- Start countdown/count-up sessions, pause/resume, record interruptions, restart/abandon and confirm measured task completion/undo.
- Lock screen, background, kill the process, change wall time/timezone and reboot during Focus. Same-boot elapsed time must remain correct; changed references require review without invented time. No notification delivery is currently promised.
- TalkBack, keyboard/switch paths, 200% text, narrow/landscape layout, dark mode and non-drag movement.
- Profile a release/profile build on representative hardware; measure startup, scrolling, schedule recomputation, memory and battery. No device performance figures exist yet.
- Verify backup exclusions, merged components/permissions, native 16 KB alignment and release signer identity.
- Test calendar import, reminders, account/sync/deletion, public sharing and biometric controls only after real implementations exist; these acceptance gates remain open.

Owner prerequisites: confirm application ID, provide a protected upload key, privacy/support URLs and reviewed disclosures, configure/deploy optional services and use Play Console to create internal/closed test tracks. No real tester participation, production-access approval or publication is claimed.

29 October limited evidence: native clock/file-backed repository probes passed on an isolated ARM64 Android 36 emulator for paused database reopen, actual force-stop, reboot, and background/screen-off followed by force-stop/recovery. Reboot retained measured time and required review. This establishes those probe behaviours only; the complete Focus UI journey, physical-device policies, wall-clock/timezone movement and all accessibility/notification exercises still need execution. No item above is fully signed off by these probes.
