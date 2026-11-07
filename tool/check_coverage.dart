import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 2 || !['mobile', 'package'].contains(arguments[1])) {
    stderr.writeln(
      'Usage: dart tool/check_coverage.dart <lcov.info> <mobile|package>',
    );
    exitCode = 2;
    return;
  }
  final coveredLines = <String, bool>{};
  String? source;
  for (final line in File(arguments[0]).readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final candidate = line.substring(3).replaceAll('\\', '/');
      final generated =
          candidate.endsWith('.g.dart') || candidate.endsWith('.freezed.dart');
      final included =
          arguments[1] == 'package' ||
          RegExp(r'/(domain|application)/').hasMatch(candidate);
      source = !generated && included ? candidate : null;
    } else if (source != null && line.startsWith('DA:')) {
      final fields = line.substring(3).split(',');
      final key = '$source:${int.parse(fields[0])}';
      coveredLines[key] =
          (coveredLines[key] ?? false) || int.parse(fields[1]) > 0;
    }
  }
  final found = coveredLines.length;
  final hit = coveredLines.values.where((covered) => covered).length;
  if (found == 0) {
    stderr.writeln(
      'Coverage failed: no eligible domain/application lines in ${arguments[0]}.',
    );
    exitCode = 1;
    return;
  }
  final percent = 100 * hit / found;
  stdout.writeln(
    '${arguments[1]} coverage: $hit/$found (${percent.toStringAsFixed(1)}%). Required: 80%.',
  );
  if (hit * 100 < found * 80) exitCode = 1;
}
