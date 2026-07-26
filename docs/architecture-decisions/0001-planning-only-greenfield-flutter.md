# ADR 0001: Planning-Only Greenfield Flutter Direction

## Status

Proposed

## Context

The reference repository is a React/TypeScript web planner. Dayweft is intended to be a new production-quality Flutter mobile application for iOS and Android, not a migration or translation.

## Decision

Use the reference only for product intent and behaviour audit. Build a new Flutter monorepo with pure Dart domain and adaptive scheduling packages. Do not port React components, browser storage strategy, AI gateway implementation or delete-and-reinsert sync behaviour.

## Consequences

- Dayweft can be local-first and mobile-native from the beginning.
- More up-front architecture is required before visible features ship.
- The Adaptive Engine can be tested independently of Flutter and cloud services.
- Reference UI and copy are treated as inspiration only and must be rebranded.
