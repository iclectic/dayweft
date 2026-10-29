# Dayweft engineering rules

- Preserve the existing Flutter monorepo, local-first behaviour and pure Dart engine.
- Local use must work offline without an account. Never initialise remote services implicitly.
- Use British English. No productivity scores, streak pressure, medical claims or monetisation.
- Adaptive changes require a concrete preview, explicit confirmation, version checks and durable undo.
- Never discard tasks to make a schedule feasible. Keep uncertainty and unscheduled work visible.
- Database changes need non-destructive migrations and real-row upgrade tests. Do not edit generated Dart files manually.
- Significant behaviour needs meaningful regression tests through the real repository/controller chain.
- Run formatting, analysis and relevant tests; record commands actually executed.
- Keep private content and credentials out of logs, telemetry, source control and public shares.
- No service-role key belongs in the client. Sharing requires a real secured hosted endpoint.
- Release builds must never use debug signing. No store upload, production deployment or irreversible data operation without owner authorisation.
- Preserve uncommitted work. Do not force-push, rewrite history or remove tests to pass checks.
- Run agent tasks sequentially in the main thread. Independent tool calls may run concurrently.
- Update docs/ROADMAP.md and docs/implementation-status.md after substantial work. Distinguish automated, device and live-backend evidence.
- A dependency, table, screen or successful debug build does not establish completion.
