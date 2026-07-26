import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

void main() {
  test('time windows report overlaps', () {
    final day = DateTime(2026, 7, 26);
    final first = TimeWindow(
      start: DateTime(day.year, day.month, day.day, 9),
      end: DateTime(day.year, day.month, day.day, 10),
    );
    final second = TimeWindow(
      start: DateTime(day.year, day.month, day.day, 9, 30),
      end: DateTime(day.year, day.month, day.day, 10, 30),
    );

    expect(first.overlaps(second), isTrue);
  });

  test('reweave strategy labels use Dayweft terminology', () {
    expect(ReweaveStrategy.protectEssentials.label, 'Protect Essentials');
    expect(ReweaveStrategy.balancedReweave.label, 'Balanced Reweave');
    expect(ReweaveStrategy.reducePressure.label, 'Reduce Pressure');
  });
}
