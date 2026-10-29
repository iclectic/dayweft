#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
expected_sdk="$(cat .flutter-version)"
actual_sdk="$(flutter --version --machine | python3 -c 'import json,sys; print(json.load(sys.stdin)["frameworkVersion"])')"
if [[ "$actual_sdk" != "$expected_sdk" ]]; then
  printf 'Expected Flutter %s; found %s. See docs/DEVELOPMENT.md.\n' "$expected_sdk" "$actual_sdk" >&2
  exit 1
fi
for package in apps/dayweft_mobile packages/dayweft_design_system; do
  (cd "$package" && flutter pub get --enforce-lockfile)
done
for package in packages/dayweft_domain packages/adaptive_day_engine; do
  (cd "$package" && dart pub get --enforce-lockfile)
done
generated_file=apps/dayweft_mobile/lib/core/database/dayweft_database.g.dart
generated_before="$(mktemp)"
trap 'rm -f "$generated_before"' EXIT
cp "$generated_file" "$generated_before"
(cd apps/dayweft_mobile && dart run build_runner build)
if ! cmp -s "$generated_file" "$generated_before"; then
  printf 'Generated database drift. Regenerate and review the generated diff.\n' >&2
  exit 1
fi
dart format --output=none --set-exit-if-changed apps packages tool
for package in apps/dayweft_mobile packages/dayweft_design_system; do
  (cd "$package" && flutter analyze && flutter test --coverage)
done
for package in packages/dayweft_domain packages/adaptive_day_engine; do
  (cd "$package" && dart analyze && dart test --coverage=coverage && dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib)
  dart tool/check_coverage.dart "$package/coverage/lcov.info" package
done
dart tool/check_coverage.dart apps/dayweft_mobile/coverage/lcov.info mobile
if [[ "${BUILD_ANDROID_DEBUG:-0}" == 1 ]]; then
  (cd apps/dayweft_mobile && flutter build apk --debug)
fi
