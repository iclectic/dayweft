import 'dayweft_domain_base.dart';

class DayTemplate {
  const DayTemplate({
    required this.id,
    required this.name,
    required this.blocks,
    this.version,
  });
  final String id;
  final String name;
  final List<TemplateBlock> blocks;
  final int? version;
}

class TemplateBlock {
  const TemplateBlock({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.blockType,
    required this.category,
    this.id,
    this.travelBufferMinutes = 0,
    this.preparationBufferMinutes = 0,
    this.transitionBufferMinutes = 0,
    this.recoveryBufferMinutes = 0,
  });
  final String title;
  final String startTime;
  final String endTime;
  final String blockType;
  final String category;
  final String? id;
  final int travelBufferMinutes;
  final int preparationBufferMinutes;
  final int transitionBufferMinutes;
  final int recoveryBufferMinutes;
}

int _clockMinute(String text) {
  final parts = text.split(':').map(int.parse).toList();
  return parts[0] * 60 + parts[1];
}

String? templateDefinitionIssue(DayTemplate template) {
  if (template.id.isEmpty ||
      template.id.length > 200 ||
      template.name.trim().isEmpty ||
      template.name.length > 80 ||
      template.blocks.isEmpty ||
      template.blocks.length > 100) {
    return 'Use a template name of 1–80 characters and between 1 and 100 blocks.';
  }
  final identities = <String>{};
  final clock = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
  for (final block in template.blocks) {
    if (block.title.trim().isEmpty ||
        block.title.length > 500 ||
        block.category.length > 80 ||
        !clock.hasMatch(block.startTime) ||
        !clock.hasMatch(block.endTime) ||
        block.startTime == block.endTime ||
        !BlockType.values.any((type) => type.name == block.blockType)) {
      return 'Each block needs a title, valid times, a category up to 80 characters and a valid type.';
    }
    if (block.id != null &&
        (block.id!.isEmpty ||
            block.id!.length > 200 ||
            !identities.add(block.id!))) {
      return 'Every template block must have a distinct identity.';
    }
    final buffers = [
      block.travelBufferMinutes,
      block.preparationBufferMinutes,
      block.transitionBufferMinutes,
      block.recoveryBufferMinutes,
    ];
    final duration =
        (_clockMinute(block.endTime) - _clockMinute(block.startTime) + 1440) %
        1440;
    if (buffers.any((value) => value < 0 || value > 1440) ||
        buffers.fold<int>(0, (total, value) => total + value) > duration) {
      return 'Reserved buffers must fit inside each template block.';
    }
  }
  return null;
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
  final issue = templateDefinitionIssue(template);
  if (issue != null ||
      workingWindow.duration <= Duration.zero ||
      transition.isNegative) {
    throw ArgumentError(
      issue ?? 'Use a valid working window and transition buffer.',
    );
  }

  final anchor = _clockMinute(template.blocks.first.startTime);
  final occupied = [...existing.map((value) => value.window)];
  final placements = <TemplatePlacement>[];
  final omissions = <TemplateOmission>[];
  for (var index = 0; index < template.blocks.length; index++) {
    final block = template.blocks[index];
    final startMinute = _clockMinute(block.startTime);
    final endMinute = _clockMinute(block.endTime);
    final sourceId = 'template:${template.id}:${block.id ?? index}';
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
