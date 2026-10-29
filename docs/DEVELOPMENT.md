# Development

Use Flutter **3.47.8 stable / Dart 3.13.7**, pinned in `.flutter-version`. The verification script enforces this release; CI still follows stable and needs a matching workflow pin. Install Flutter from the official stable distribution. Do not run an SDK upgrade implicitly. Python 3 is used only for reading Flutter machine output in scripts. Android builds use JDK 21 with Java bytecode level 17, SDK 36, minimum API 24, Gradle 9.1.0, AGP 9.0.1 and Kotlin 2.3.21. These versions passed the Android debug build. Flutter still warns about the application's legacy Kotlin plugin; built-in Kotlin migration remains pending.

From the repository root:

```sh
bash scripts/verify.sh
BUILD_ANDROID_DEBUG=1 bash scripts/verify.sh
```

The script enforces lockfiles, regenerates Drift and detects drift, checks formatting/analysis, runs all four suites and separate 80% domain/application coverage gates. It does not claim device or backend verification. The `build_runner` delete-conflicting-outputs option has been removed upstream; use `dart run build_runner build` in the mobile package.

Run locally without accounts or credentials:

```sh
cd apps/dayweft_mobile
flutter run --dart-define=APP_ENV=development
```

`APP_ENV` accepts development, staging or production and rejects unknown values. All environments currently start locally; configuration alone never starts Supabase, analytics or uploads private content. Cloud adapters and explicit synchronisation opt-in remain unfinished.

The clock is injectable through Riverpod and repository constructors; selected civil dates are explicit. Dates advance by calendar components rather than elapsed 24-hour durations. Android Focus now uses elapsed realtime and a boot reference, with review required when that reference changes. Native lifecycle exercises and IANA timezone/recurrence policy remain pending. Never describe those gaps as resolved by a clock abstraction.

Keep generated Drift output and private-monorepo package lockfiles in git. Never hand-edit generated code, production secrets, signing keys or database files. See [testing](testing.md), [dependencies](DEPENDENCIES.md), [architecture](architecture.md) and [release](RELEASE.md).
