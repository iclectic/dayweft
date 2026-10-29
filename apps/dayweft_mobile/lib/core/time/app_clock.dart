import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class AppClock {
  DateTime now();
}

class SystemAppClock implements AppClock {
  const SystemAppClock();

  @override
  DateTime now() => DateTime.now();
}

final appClockProvider = Provider<AppClock>((ref) => const SystemAppClock());

DateTime civilDate(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime adjacentDate(DateTime value, int days) =>
    DateTime(value.year, value.month, value.day + days);
