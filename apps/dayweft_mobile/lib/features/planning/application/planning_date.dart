import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Null follows the current device day; selecting a date pins a civil date.
final planningDateProvider = NotifierProvider<PlanningDate, DateTime?>(
  PlanningDate.new,
);

class PlanningDate extends Notifier<DateTime?> {
  @override
  bool updateShouldNotify(DateTime? previous, DateTime? next) => true;

  @override
  DateTime? build() => null;

  void select(DateTime date) => state = civilDate(date);

  void today() => state = null;

  void move(int days) =>
      select(adjacentDate(state ?? ref.read(appClockProvider).now(), days));
}
