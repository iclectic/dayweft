#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../apps/dayweft_mobile"
if [[ ! -f android/key.properties ]]; then
  printf 'Release blocked: configure the owner upload key in android/key.properties. See docs/RELEASE.md.\n' >&2
  exit 1
fi
if [[ "${DAYWEFT_ANDROID_ID_CONFIRMED:-}" != yes ]]; then
  printf 'Release blocked: owner must confirm the application ID, then set DAYWEFT_ANDROID_ID_CONFIRMED=yes.\n' >&2
  exit 1
fi
flutter build appbundle --release --dart-define=APP_ENV=production "$@"
