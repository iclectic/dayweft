# Contributing

Dayweft is local-first and privacy-first. Keep domain logic outside widgets, avoid logging personal content and add tests for behaviour changes.

## Standards

- Use sound null safety.
- Keep the Adaptive Engine pure Dart.
- Save locally before remote sync work.
- Do not commit secrets or environment files.
- Prefer explicit typed failures over generic exceptions at domain boundaries.
- Update documentation when product behaviour, privacy posture or architecture changes.

## Validation

Run the relevant package tests before opening a change. For cross-package work, run all checks listed in `README.md`.
