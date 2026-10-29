# Security verification checkpoint

27 October 2026. This records executed checks, not a completed production security audit.

- Gitleaks v8.30.1 was downloaded from its official release and its archive SHA-256 checked against the publisher's checksum manifest. The Darwin ARM64 digest was `b40ab0ae55c505963e365f271a8d3846efbc170aa17f2607f13df610a9aeb6a5`.
- Ran `gitleaks dir . --redact=100 --no-banner --report-format json` and `gitleaks git . --log-opts=--all --redact=100 --no-banner --report-format json`: no leaks found. Reports remained outside the repository. Build/dependency caches are excluded in `.gitleaks.toml`; application source is not excluded.
- Queried the [OSV batch API](https://google.github.io/osv.dev/api/) with 165 unique hosted Pub package/version pairs from all lockfiles after dependency updates: no advisory matches. No planning content, credentials or account data was transmitted.
- Strict day-import validation rejects unsupported product/schema, malformed rows, invalid dates/types/durations/references and dependency cycles before writes. Duplicate detection and application are transactional. Source task text is rendered as text, not executed or sent to a remote model.
- Android disables cleartext transport and automatic backup/device transfer of private application data. Actual OEM backup behaviour is not yet device-verified; SQLite is not claimed to be encrypted.
- Production signing has no debug fallback. Missing upload credentials fail closed. The existing application ID is provisional until owner confirmation.
- The Android Focus time channel exposes only wall-clock/elapsed-time/boot-reference values. No new permission, background service or sensitive logging was added.

Remaining work: full native/transitive licence review, release-binary 16 KB verification, complete privacy deletion, biometric/session controls, real native permission testing, and adversarial auth/sync/sharing validation once implemented. Existing calendar/share controls are still scaffolds; no hosted revocation or secure public sharing is claimed. CI still needs integration of the real scanner and an explicit SDK pin.

## 29 October continuation

- Re-fetched pinned Gitleaks v8.30.1; its archive SHA-256 matched the previously verified digest above. Ran `gitleaks dir . --redact=100 --no-banner --report-format json --report-path /private/tmp/dayweft-2026-10-29-gitleaks.json`: no leaks found. This is a fresh worktree scan, not a new full-history claim.
- OSV batch lookup of the three newly added test-only public versions (`process` 5.0.6, `sync_http` 0.3.1, `webdriver` 3.2.0) returned three empty results. Runtime versions did not change; the prior 165-version result remains dated 27 October.
- Custom templates are stored locally and validate name, block count, types, clock times, distinct identities and internal buffers. Transactional version checks protect edits/deletion/restore and application previews. Malformed stored data produces a safe error rather than a database reset. Saving from a day copies block names/categories/times/buffers only; tasks, notes and source provenance are excluded. Names remain private planning data and are not logged.
- Native probes use a separate fixture database and contain only labelled test content and numeric timing markers. No permissions, foreground service, telemetry, new remote initialiser or production backend were added. The added SDK integration tooling is development-only.
- No new known critical/high security issue was identified in this slice. This does not close the release security/privacy gates or certify unimplemented backend/native features.
