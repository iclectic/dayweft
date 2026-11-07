import 'package:dayweft_mobile/features/quiet_focus/domain/focus_time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class PlatformFocusTime implements FocusTimeSource {
  PlatformFocusTime();
  static const _channel = MethodChannel('app.dayweft/focus_time');
  final _stopwatch = Stopwatch()..start();
  final _processToken = const Uuid().v4();

  @override
  Future<FocusTimeReading> read() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final value = await _channel.invokeMapMethod<String, Object?>('read');
        if (value != null &&
            value['wallMilliseconds'] is int &&
            value['elapsedMilliseconds'] is int &&
            value['bootToken'] is String) {
          return FocusTimeReading(
            wallTime: DateTime.fromMillisecondsSinceEpoch(
              value['wallMilliseconds']! as int,
            ),
            monotonicMilliseconds: value['elapsedMilliseconds']! as int,
            bootToken: value['bootToken']! as String,
          );
        }
      } on MissingPluginException {
        // Other platforms can resume within this process; a new process requires review.
      } on PlatformException {
        // A changed reference is detected by the durable state machine.
      }
    }
    return FocusTimeReading(
      wallTime: DateTime.now(),
      monotonicMilliseconds: _stopwatch.elapsedMilliseconds,
      bootToken: 'process:$_processToken',
    );
  }
}
