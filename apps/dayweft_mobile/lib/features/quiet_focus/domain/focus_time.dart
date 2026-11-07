class FocusTimeReading {
  const FocusTimeReading({
    required this.wallTime,
    required this.monotonicMilliseconds,
    required this.bootToken,
  });
  final DateTime wallTime;
  final int monotonicMilliseconds;
  final String bootToken;
}

abstract interface class FocusTimeSource {
  Future<FocusTimeReading> read();
}
