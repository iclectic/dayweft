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
