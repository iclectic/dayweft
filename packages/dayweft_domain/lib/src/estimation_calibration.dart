/// Observational duration evidence. No task text is needed for calibration.
class DurationSample {
  const DurationSample({
    required this.estimatedMinutes,
    required this.actualMinutes,
    this.category,
    this.timeOfDay,
    this.dayOfWeek,
    this.interruptionCount = 0,
    this.wasSplit = false,
    this.excluded = false,
  });

  final int estimatedMinutes;
  final int actualMinutes;
  final String? category;
  final String? timeOfDay;
  final int? dayOfWeek;
  final int interruptionCount;
  final bool wasSplit;
  final bool excluded;
}

class CalibrationSummary {
  const CalibrationSummary({
    required this.sampleSize,
    required this.minimumSamples,
    this.factor,
    this.lowerQuartile,
    this.upperQuartile,
  });

  final int sampleSize;
  final int minimumSamples;
  final double? factor;

  /// Empirical middle-half spread, not a confidence interval.
  final double? lowerQuartile;
  final double? upperQuartile;
  bool get hasEnoughEvidence => factor != null;
}

class EstimationCalibration {
  const EstimationCalibration({this.minimumSamples = 12});
  final int minimumSamples;

  CalibrationSummary summarise(
    Iterable<DurationSample> samples, {
    String? category,
    String? timeOfDay,
    int? dayOfWeek,
    bool? wasSplit,
  }) {
    if (minimumSamples < 2) {
      throw ArgumentError.value(minimumSamples, 'minimumSamples');
    }
    final ratios =
        samples
            .where(
              (sample) =>
                  !sample.excluded &&
                  sample.estimatedMinutes > 0 &&
                  sample.actualMinutes > 0 &&
                  (category == null || sample.category == category) &&
                  (timeOfDay == null || sample.timeOfDay == timeOfDay) &&
                  (dayOfWeek == null || sample.dayOfWeek == dayOfWeek) &&
                  (wasSplit == null || sample.wasSplit == wasSplit),
            )
            .map((sample) => sample.actualMinutes / sample.estimatedMinutes)
            .toList()
          ..sort();
    if (ratios.length < minimumSamples) {
      return CalibrationSummary(
        sampleSize: ratios.length,
        minimumSamples: minimumSamples,
      );
    }
    return CalibrationSummary(
      sampleSize: ratios.length,
      minimumSamples: minimumSamples,
      factor: _quantile(ratios, 0.5),
      lowerQuartile: _quantile(ratios, 0.25),
      upperQuartile: _quantile(ratios, 0.75),
    );
  }

  double _quantile(List<double> sorted, double percentile) {
    final position = (sorted.length - 1) * percentile;
    final lower = position.floor();
    final upper = position.ceil();
    return sorted[lower] + (sorted[upper] - sorted[lower]) * (position - lower);
  }
}
