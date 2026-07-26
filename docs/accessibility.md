# Dayweft Accessibility Plan

Target WCAG 2.2 AA where applicable.

## Baseline

- Material 3 components where they provide native semantics.
- Semantic labels for timeline blocks, current time, schedule changes, warnings and controls.
- Logical focus order for every sheet, dialog, timeline item and confirmation flow.
- Minimum 44 by 44 point touch targets.
- Sufficient contrast in light and dark mode.
- Non-colour indicators for block type, sync state, conflicts and warnings.
- Dynamic Type and text scaling without clipping or overlap.
- RTL-compatible layouts.
- Localisation-ready strings, dates and first-day-of-week rules.
- 12-hour and 24-hour formats.
- Reduced-motion setting respected across transitions, timeline movement and reweave previews.
- Keyboard and switch navigation for creation, reorder, confirmation and undo.

## Timeline Accessibility

The Today Timeline needs non-drag controls for resize, reorder and move-to-block actions. Current-time state should be announced without constantly interrupting screen readers. Original versus revised comparison needs text summaries in addition to visual thread changes.

## Reweave Accessibility

Each alternative must have a concise screen-reader summary:

- number of changes;
- protected commitments;
- deferred items;
- primary trade-off;
- confidence explanation;
- confirm and dismiss actions.

Preview changes must be accessible as a list diff, not only a visual animation.

## Testing

- Widget tests for semantics labels and focus traversal.
- Golden tests at standard, large and extra-large text scale.
- Reduced-motion tests for reweave and timeline transitions.
- RTL layout smoke tests.
- Manual screen-reader pass before release milestones on iOS and Android.
