enum AppEnvironment { development, staging, production }

/// Build-time configuration contains no private credentials and enables no
/// network client. Cloud services require their own explicit user opt-in.
class AppConfiguration {
  const AppConfiguration({required this.environment});

  factory AppConfiguration.fromName(String name) {
    return AppConfiguration(
      environment: AppEnvironment.values.firstWhere(
        (value) => value.name == name,
        orElse: () => throw ArgumentError.value(name, 'APP_ENV'),
      ),
    );
  }

  factory AppConfiguration.fromBuild() => AppConfiguration.fromName(
    const String.fromEnvironment('APP_ENV', defaultValue: 'development'),
  );

  final AppEnvironment environment;
}
