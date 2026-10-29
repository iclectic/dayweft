# Continuation verification: 29 October 2026

Scope: custom-template library and workflow/native Focus regression work based on `455091d`, on `feat/dayweft-plan-completion`. This verifies the named slices; Dayweft 1.0 remains unfinished.

| Check actually run | Result |
| --- | --- |
| `bash scripts/verify.sh` | Passed end to end, including final large-text regression |
| Four locked resolutions and Drift regeneration comparison | Passed; generated code matches schema v12 |
| `dart format --output=none --set-exit-if-changed apps packages tool` | Passed, 77 files checked |
| Analysis of all four packages | Passed, no issues |
| Mobile tests with coverage | 110 passed |
| Shared domain tests | 21 passed |
| Adaptive engine tests | 15 passed |
| Design-system tests | 2 passed |
| Mobile domain/application coverage | 363/375, 96.8% |
| Shared domain coverage | 221/247, 89.5% |
| Adaptive engine coverage | 403/447, 90.2% |
| `flutter build apk --debug` (normal mobile entry point) | Passed, 11.9s Gradle task; existing legacy Kotlin-plugin warning remains |
| Gitleaks v8.30.1 worktree scan | No leaks found |
| OSV lookup of three newly added public test-only versions | No advisory matches |
| `git diff --check` | Passed |

Toolchain remains Flutter 3.47.8 stable, Dart 3.13.7, JDK 21, bytecode 17, Gradle 9.1.0, AGP 9.0.1, Kotlin 2.3.21, compile/target API 36 and minimum API 24. No signed release build was attempted without owner signing access. Normal debug APK: `apps/dayweft_mobile/build/app/outputs/flutter-apk/app-debug.apk` (ignored build output).

## Verified local behaviour

The custom library uses the existing Drift/Riverpod architecture. Tests exercise actual SQLite and controllers: create/edit/rename/duplicate, stable block identities/buffers, saving reviewed block settings without task details, confirm/cancel deletion, deletion undo after closing the sheet, stale edit/application rejection, capacity and malformed content, file close/reopen and non-destructive v11 migration. Selected template application remains additive, duplicate-safe and reversible. Existing starter templates and previous planning tests remain intact.

New widget workflows cover civil-date navigation/new-block/isolated undo, selected template application/cancel/stale errors, malformed/repeated day import and original-date selection. Two light/dark custom-editor goldens were generated and visually inspected, then compared in the final suite. They use Flutter's test font and are layout fixtures, not store assets. A 320px dark screen at 200% text completes template block/buffer validation and saving, with an automated Android touch-target check. These results do not certify TalkBack, keyboard/switch access or a complete Android UI journey.

## Native Android Focus evidence

Created an isolated, headless, read-only AVD instance using separate temporary userdata/cache images; existing AVD user data was not reset. Target: `Medium_Phone_API_36.0`, ARM64 Android 36, serial `emulator-5554`, SwiftShader rendering. Tests assert the real native `boot:<count>` reference and use a separate file-backed fixture database. No clock MethodChannel mock is used.

| Probe actually executed | Observation |
| --- | --- |
| `roundtrip`: start, measure, pause, close/reopen SQLite, resume/abandon | 1,168ms measured; paused elapsed value retained; no active session after finishing |
| `seed` for process/reboot exercise | Running session checkpoint at 1,153ms |
| Actual `adb ... shell am force-stop app.dayweft.dayweft_mobile`, then `recover` | Same boot; running session recovered at 196,116ms, beyond persisted 1,153ms |
| Actual `adb ... reboot`, await completed boot, then `afterReboot` | Boot reference changed; status `needsReview`; persisted 196,135ms retained exactly; no unknown downtime added; explicit resume/abandon succeeded |
| Second `seed`, Home and `KEYCODE_SLEEP` | New fixture checkpoint 1,173ms; `dumpsys power` reported `mWakefulness=Asleep` |
| Wake, dismiss test keyguard, actual force-stop, then `recover` | Same boot; running session recovered at 207,429ms, beyond persisted 1,173ms |

All six probe executions passed (one actual test case per execution; driver teardown output is not an extra test). These establish native clock/file-persistence behaviour on this emulator. They do not verify notification delivery, countdown UI while locked, real-hardware power management, wall-clock/timezone changes, TalkBack, physical-device restart or release performance. The underlying repository's fake-clock tests cover additional deterministic transitions; that remains automated evidence, not hardware evidence.

Exact commands and fixture cautions are in [testing](../testing.md#native-focus-probes-on-a-disposable-android-emulator). `roundtrip` used `flutter test integration_test/focus_native_test.dart -d emulator-5554 --reporter expanded`. Subsequent stages used `flutter drive -d emulator-5554 --driver=test_driver/integration_test.dart --target=integration_test/focus_native_test.dart --dart-define=FOCUS_LIFECYCLE_STAGE=<stage> --keep-app-running`. Driver retention is necessary because `flutter test` removes its app after a run. Numeric `DAYWEFT_NATIVE_FOCUS_EVIDENCE` markers and host logs were kept outside the repository under `/private/tmp/dayweft-native-*.log`; the table above preserves their observations.

## Review, failures and corrections

Correctness, maintainability, data-migration, API-contract, reliability, security and test checks were performed sequentially in the main thread under `AGENTS.md`. No independent reviewer or fresh GitHub Actions run is claimed. Simplification consolidated post-write refresh handling in the library controller; existing input validation and architecture were preserved.

- Test-first repository cases initially failed while custom persistence/domain fields were absent; implementation made them pass.
- Review found that a corrupt unrelated template could cause refresh to report a committed save as failed. A regression reproduced the failure; guarded refresh now shows the library read error while preserving the successful write result.
- Deletion undo captures the live library controller/messenger so closing its sheet does not invalidate undo. Capacity also applies to restoration; stale restoration cannot overwrite newer edits.
- Large-text test interactions initially targeted partially off-screen controls and an inner text-field scroll view; after correcting focus/scroll settling and selecting the actual outer scroll view, the complete buffer workflow passed. The semantics handle is disposed before end-of-test verification.
- The staged native runner initially used `flutter test`, which removed its app between stages. The final driver-based sequence preserves its fixture across actual process termination and reboot. Active-state queries select only the active fixture, allowing completed historical test sessions to remain.

No unresolved actionable finding in this slice remains. This does not close the broader roadmap's known gaps.

## Operational validation for the next candidate

The owner runs this during internal testing, before rollout. On an upgraded local database verify `PRAGMA user_version = 12`; historical task/plan/focus rows remain; the new template library starts empty. Check active template count is at most 500 and active Focus-state count at most one. Create/edit/apply/undo a pattern around existing work, close/reopen, retry an old preview, and confirm deletion/undo never touches existing days. Do not log private block/task names for diagnosis.

Healthy signals: unchanged pre-existing rows, deterministic placements/omissions, rejected stale versions, working deletion undo, retained measured Focus time and review after changed boot reference. Stop candidate distribution for migration errors, lost/duplicated work or elapsed-time corruption. Preserve a private database copy for diagnosis and ship a forward repair; do not lower schema version or delete a user's database. No production deployment occurred.

Remaining release gates include recurrence/exceptions, complete hard windows/splits, full backups, native calendar/reminders/capture, optional backend/sharing/privacy controls, hardware accessibility/performance, final identity/upload signing, genuine store assets and owner-controlled Play testing/approval.
