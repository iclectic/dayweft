# Dependency and security review

Baseline: 26 October 2026. This is an inventory and source review, not a completed vulnerability or legal audit.

## Toolchain

Installed Flutter 3.47.8 stable / Dart 3.13.7. Current official [Flutter release documentation](https://docs.flutter.dev/release/release-notes/release-notes-3.47.0) confirms the 3.47 line. Local debug build passed with AGP 8.11.1, Gradle 8.14, Kotlin 2.2.20 and JDK 21.0.10, with forward-support warnings. The [AGP compatibility reference](https://developer.android.com/build/releases/agp-8-13-0-release-notes) and [Flutter Kotlin migration guide](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin) must inform upgrades; plugin compatibility must be tested, not inferred from latest version numbers.

## Dependencies

| Dependency group | Baseline use | Review action |
| --- | --- | --- |
| Riverpod, go_router, Drift, path/provider, uuid, intl | Active application/persistence | Retain; reproduce with committed application lockfile |
| Pure Dart engine/domain | Local path packages | Retain strict boundaries and separate tests |
| flutter_local_notifications, timezone | Declared, native scheduling unused | Retain only with implementation; actual delivery/permission tests required |
| local_auth, flutter_secure_storage | Declared; app lock/auth not implemented | Do not claim protection from dependency presence |
| supabase_flutter | Declared, not initialised | No live infrastructure or RLS; retain local mode and require explicit configured consent |
| Freezed/json annotations/generators | Declared, no annotated application models | Review/remove genuinely unused generators rather than inventing models to justify them |
| sqlite3_flutter_libs 0.6.0+eol | End-of-life stub; sqlite3 3.x already supplies native assets | Remove redundant direct dependency and rebuild Android |
| cupertino_icons | No verified direct use | Remove if source search confirms unused |

`flutter pub get` succeeded but reported 89 newer constrained/transitive releases. A mass upgrade is not justified without compatibility tests. Package/native licences, OSV advisories and 16 KB native alignment require evidence before release; none is assumed from dependency resolution. Record subsequent checks in [security verification](../security/verification-report.md).

## Source/security findings

- Release is debug-signed: critical release configuration defect, not a production credential leak.
- Android application backup is not explicitly restricted; unencrypted private planning data needs a documented exclusion policy.
- Supabase is not initialised. No private task transmission is currently implemented.
- Import is bounded to 5 MB/500 blocks/2,000 tasks, but schema and strict malformed-row validation are missing.
- Share drafts use unhashed UUID text and have no public endpoint. They must not be advertised as secure sharing.
- Initial CI grep is not a genuine secret scan. Gitleaks/history scanning and advisory scanning remain required until executed.
- Application-generated log output and task-bearing exception rendering need review. Do not put raw imported content, auth tokens or share tokens into diagnostics.

Do not interpret “no known leak found in reviewed files” as a verified clean scan or claim encryption, E2EE, biometric gating or working cloud deletion.
