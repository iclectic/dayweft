import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

void main() {
  test('historical actuals do not silently change planned work', () {
    const task = DayweftTask(
      id: 'measured',
      title: 'Work',
      estimatedDuration: Duration(minutes: 20),
      actualDuration: Duration(minutes: 35),
      status: TaskStatus.planned,
    );
    const completed = DayweftTask(
      id: 'done',
      title: 'Done',
      estimatedDuration: Duration(minutes: 20),
      actualDuration: Duration(minutes: 35),
      status: TaskStatus.completed,
    );
    expect(task.planningDuration, const Duration(minutes: 20));
    expect(completed.planningDuration, Duration.zero);
  });
  const calibration = EstimationCalibration();
  test('no factor is inferred from insufficient or invalid evidence', () {
    final result = calibration.summarise([
      for (var i = 0; i < 11; i++)
        const DurationSample(estimatedMinutes: 10, actualMinutes: 20),
      const DurationSample(estimatedMinutes: 0, actualMinutes: 20),
      const DurationSample(estimatedMinutes: 10, actualMinutes: -1),
      const DurationSample(
        estimatedMinutes: 10,
        actualMinutes: 20,
        excluded: true,
      ),
    ]);
    expect(result.sampleSize, 11);
    expect(result.factor, isNull);
    expect(result.lowerQuartile, isNull);
  });
  test('median and spread describe evidence without outlier domination', () {
    final result = calibration.summarise([
      for (var i = 0; i < 11; i++)
        const DurationSample(estimatedMinutes: 10, actualMinutes: 20),
      const DurationSample(estimatedMinutes: 10, actualMinutes: 1000),
    ]);
    expect(result.factor, 2);
    expect(result.lowerQuartile, 2);
    expect(result.upperQuartile, 2);
    expect(result.sampleSize, 12);
  });
  test('category and context cohorts have independent evidence thresholds', () {
    final samples = [
      for (var i = 0; i < 12; i++)
        const DurationSample(
          estimatedMinutes: 10,
          actualMinutes: 20,
          category: 'study',
          timeOfDay: 'morning',
          dayOfWeek: 1,
          wasSplit: true,
        ),
      const DurationSample(
        estimatedMinutes: 10,
        actualMinutes: 5,
        category: 'work',
      ),
    ];
    expect(calibration.summarise(samples, category: 'work').factor, isNull);
    expect(
      calibration
          .summarise(
            samples,
            category: 'study',
            timeOfDay: 'morning',
            dayOfWeek: 1,
            wasSplit: true,
          )
          .factor,
      2,
    );
    expect(
      calibration
          .summarise(samples, category: 'study', wasSplit: false)
          .sampleSize,
      0,
    );
  });
}
