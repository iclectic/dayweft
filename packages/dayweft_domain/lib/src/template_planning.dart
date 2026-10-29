import 'dayweft_domain_base.dart';

class DayTemplate {
  const DayTemplate({
    required this.id,
    required this.name,
    required this.blocks,
  });
  final String id;
  final String name;
  final List<TemplateBlock> blocks;
}

class TemplateBlock {
  const TemplateBlock({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.blockType,
    required this.category,
  });
  final String title;
  final String startTime;
  final String endTime;
  final String blockType;
  final String category;
}

class TemplateReservation {
  const TemplateReservation({required this.window, this.sourceId});
  final TimeWindow window;
  final String? sourceId;
}

class TemplatePlacement {
  const TemplatePlacement({
    required this.index,
    required this.block,
    required this.window,
    required this.sourceId,
  });
  final int index;
  final TemplateBlock block;
  final TimeWindow window;
  final String sourceId;
}

class TemplateOmission {
  const TemplateOmission(this.title, this.reason);
  final String title;
  final String reason;
}

class TemplatePreview {
  TemplatePreview({
    required this.template,
    required this.planId,
    required this.baseRevision,
    required List<TemplatePlacement> placements,
    required List<TemplateOmission> omissions,
  }) : placements = List.unmodifiable(placements),
       omissions = List.unmodifiable(omissions);
  final DayTemplate template;
  final String planId;
  final int baseRevision;
  final List<TemplatePlacement> placements;
  final List<TemplateOmission> omissions;
}

/// Preserves durations and offsets from the first block, anchored to the
/// person's working window. Existing reservations always take precedence.
TemplatePreview reconcileTemplate({
  required DayTemplate template,
  required String planId,
  required int revision,
  required TimeWindow workingWindow,
  required List<TemplateReservation> existing,
  Duration transition = Duration.zero,
}) {
  if (template.id.isEmpty ||
      template.blocks.isEmpty ||
      template.blocks.length > 100 ||
      workingWindow.duration <= Duration.zero ||
      transition.isNegative) {
    throw ArgumentError('Use a non-empty template and a valid working window.');
  }
  int minute(String text) {
    if (!RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$').hasMatch(text)) {
      throw ArgumentError('Template times must use HH:mm.');
    }
    final parts = text.split(':').map(int.parse).toList();
    return parts[0] * 60 + parts[1];
  }

  final anchor = minute(template.blocks.first.startTime);
  final occupied = [...existing.map((value) => value.window)];
  final placements = <TemplatePlacement>[];
  final omissions = <TemplateOmission>[];
  for (var index = 0; index < template.blocks.length; index++) {
    final block = template.blocks[index];
    final startMinute = minute(block.startTime);
    final endMinute = minute(block.endTime);
    if (block.title.trim().isEmpty ||
        block.title.length > 500 ||
        block.category.length > 80 ||
        !BlockType.values.any((type) => type.name == block.blockType) ||
        startMinute == endMinute) {
      throw ArgumentError(
        'Each template block needs a title, type and positive duration.',
      );
    }
    final sourceId = 'template:${template.id}:$index';
    if (existing.any(
      (value) =>
          value.sourceId == sourceId ||
          value.sourceId == 'template:${template.id}',
    )) {
      omissions.add(
        TemplateOmission(block.title, 'Already applied to this day.'),
      );
      continue;
    }
    final duration = Duration(minutes: (endMinute - startMinute + 1440) % 1440);
    final offset = (startMinute - anchor + 1440) % 1440;
    var start = workingWindow.start.add(Duration(minutes: offset));
    occupied.sort((a, b) => a.start.compareTo(b.start));
    for (final window in occupied) {
      if (!start.add(duration).add(transition).isAfter(window.start)) break;
      if (start.isBefore(window.end.add(transition))) {
        start = window.end.add(transition);
      }
    }
    final end = start.add(duration);
    if (end.isAfter(workingWindow.end)) {
      omissions.add(
        TemplateOmission(block.title, 'No room inside your working hours.'),
      );
      continue;
    }
    final window = TimeWindow(start: start, end: end);
    occupied.add(window);
    placements.add(
      TemplatePlacement(
        index: index,
        block: block,
        window: window,
        sourceId: sourceId,
      ),
    );
  }
  return TemplatePreview(
    template: template,
    planId: planId,
    baseRevision: revision,
    placements: placements,
    omissions: omissions,
  );
}
