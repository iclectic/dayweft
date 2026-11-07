import 'dart:convert';
import 'dart:io';

import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/quiet_focus/data/focus_repository.dart';
import 'package:dayweft_mobile/features/quiet_focus/data/platform_focus_time.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Run on a disposable Android emulator. The staged probes preserve only their
/// own fixture database across external force-stop/reboot commands.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const stage = String.fromEnvironment(
    'FOCUS_LIFECYCLE_STAGE',
    defaultValue: 'roundtrip',
  );

  testWidgets('native Android focus timing: $stage', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('Dayweft native Focus verification')),
      ),
    );
    final time = PlatformFocusTime();
    final initialReading = await time.read();
    expect(
      initialReading.bootToken,
      matches(RegExp(r'^boot:\d+$')),
      reason:
          'This must exercise the native Android clock, never the process-only fallback.',
    );
    final directory = stage == 'roundtrip'
        ? await Directory.systemTemp.createTemp('dayweft-native-focus-')
        : await getApplicationDocumentsDirectory();
    final file = File(
      p.join(directory.path, 'dayweft_native_focus_verification.sqlite'),
    );
    DayweftDatabase database = DayweftDatabase.forTesting(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      if (stage == 'roundtrip') await directory.delete(recursive: true);
    });
    FocusRepository repository = FocusRepository(database, time);

    if (stage == 'roundtrip') {
      var session = await repository.start(
        title: 'Native verification fixture',
        mode: FocusMode.countUp,
      );
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      session = (await repository.checkpoint())!;
      expect(session.elapsedMilliseconds, greaterThanOrEqualTo(1000));
      session = await repository.pause(session.session.id, session.version);
      final elapsed = session.elapsedMilliseconds;
      await database.close();
      database = DayweftDatabase.forTesting(NativeDatabase(file));
      repository = FocusRepository(database, time);
      session = (await repository.loadActive())!;
      expect(session.elapsedMilliseconds, elapsed);
      expect(session.session.status, 'paused');
      session = await repository.resume(session.session.id, session.version);
      await repository.finish(
        session.session.id,
        session.version,
        abandoned: true,
      );
      expect(await repository.loadActive(), isNull);
      _evidence(stage, {
        'nativeClock': true,
        'elapsedMilliseconds': elapsed,
        'fileReopenPreservedPause': true,
      });
    } else if (stage == 'seed') {
      expect(
        await repository.loadActive(),
        isNull,
        reason: 'Use a fresh disposable emulator for this fixture.',
      );
      await repository.start(
        title: 'Lifecycle verification fixture',
        mode: FocusMode.countUp,
      );
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      final session = (await repository.checkpoint())!;
      _evidence(stage, {
        'elapsedMilliseconds': session.elapsedMilliseconds,
        'nativeClock': true,
      });
    } else if (stage == 'recover') {
      final before = await (database.select(
        database.focusSessionStates,
      )..where((row) => row.active.equals(true))).getSingle();
      expect(before.bootToken, initialReading.bootToken);
      final session = (await repository.loadActive())!;
      expect(session.session.status, 'running');
      expect(
        session.elapsedMilliseconds,
        greaterThan(before.elapsedMilliseconds + 1000),
      );
      await repository.checkpoint();
      _evidence(stage, {
        'sameBoot': true,
        'persistedMilliseconds': before.elapsedMilliseconds,
        'recoveredMilliseconds': session.elapsedMilliseconds,
      });
    } else if (stage == 'afterReboot') {
      final before = await (database.select(
        database.focusSessionStates,
      )..where((row) => row.active.equals(true))).getSingle();
      expect(before.bootToken, isNot(initialReading.bootToken));
      var session = (await repository.loadActive())!;
      expect(session.session.status, 'needsReview');
      expect(session.elapsedMilliseconds, before.elapsedMilliseconds);
      session = await repository.resume(session.session.id, session.version);
      await repository.finish(
        session.session.id,
        session.version,
        abandoned: true,
      );
      _evidence(stage, {
        'bootChanged': true,
        'unknownTimeAdded': false,
        'retainedMilliseconds': before.elapsedMilliseconds,
      });
    } else {
      fail('Unknown FOCUS_LIFECYCLE_STAGE.');
    }
  });
}

void _evidence(String stage, Map<String, Object?> values) => debugPrint(
  'DAYWEFT_NATIVE_FOCUS_EVIDENCE ${jsonEncode({'stage': stage, ...values})}',
);
