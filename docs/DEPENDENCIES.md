# Dependencies

See the [baseline inventory and security review](audit/dependency-security-review.md). The application and three private package lockfiles pin resolved versions; `scripts/verify.sh` enforces them.

Active essentials: Flutter, Riverpod, go_router, Drift/SQLite native assets, path/path_provider, uuid, intl, and the three local packages. The obsolete `sqlite3_flutter_libs` stub was removed: [its publisher explicitly recommends removal with sqlite3 3.x](https://pub.dev/packages/sqlite3_flutter_libs). No application source uses Cupertino icons, Freezed annotations or json_serializable; those unused direct dependencies/generators were removed. Drift code generation remains.

Drift/build_runner are updated together to address the Dart 3.13 analyser compatibility warning. Preserve API and migration tests across regeneration. Manifest ranges are not a licence or security verdict.

Supabase, local_auth, secure storage, notifications and timezone remain reserved for the requested integrations; they are not yet functional features. Review necessity, transitive permissions, maintenance, licences and native compatibility when implementing each adapter. No new runtime plugin was added for date navigation or template safety.

Gitleaks worktree/history scans and OSV checks of 165 locked public package versions passed on 27 October 2026. Before release, complete the transitive/native licence inventory and native page-alignment checks. Empty scan results do not prove vulnerability-free dependencies. Record actual results in [security verification](security/verification-report.md).

29 October: added Flutter SDK `integration_test` as a development dependency for genuine Android clock/persistence probes. Its SDK driver/protocol dependencies and public `process` 5.0.6, `sync_http` 0.3.1 and `webdriver` 3.2.0 support the host test runner; no runtime dependency version or new production plugin changed. The three added public versions returned no OSV matches. The locked SDK and all four package resolutions pass the verification script. Custom templates use existing Drift/UUID/Riverpod dependencies.
