import 'package:dayweft_domain/dayweft_domain.dart';

const dayweftTemplates = <DayTemplate>[
  DayTemplate(
    id: 'workday',
    name: 'Workday',
    blocks: <TemplateBlock>[
      TemplateBlock(
        title: 'Plan the day',
        startTime: '09:00',
        endTime: '09:20',
        blockType: 'fixed',
        category: 'planning',
      ),
      TemplateBlock(
        title: 'Deep work',
        startTime: '09:30',
        endTime: '11:30',
        blockType: 'flexible',
        category: 'work',
      ),
      TemplateBlock(
        title: 'Admin wrap-up',
        startTime: '16:00',
        endTime: '16:45',
        blockType: 'optional',
        category: 'admin',
      ),
    ],
  ),
  DayTemplate(
    id: 'study',
    name: 'Study day',
    blocks: <TemplateBlock>[
      TemplateBlock(
        title: 'Reading block',
        startTime: '10:00',
        endTime: '11:30',
        blockType: 'flexible',
        category: 'study',
      ),
      TemplateBlock(
        title: 'Practice questions',
        startTime: '13:00',
        endTime: '14:30',
        blockType: 'flexible',
        category: 'study',
      ),
    ],
  ),
  DayTemplate(
    id: 'recovery',
    name: 'Recovery day',
    blocks: <TemplateBlock>[
      TemplateBlock(
        title: 'Low-pressure essentials',
        startTime: '10:00',
        endTime: '11:00',
        blockType: 'fixed',
        category: 'admin',
      ),
      TemplateBlock(
        title: 'Recovery time',
        startTime: '14:00',
        endTime: '15:00',
        blockType: 'fixed',
        category: 'rest',
      ),
    ],
  ),
  DayTemplate(
    id: 'shift',
    name: 'Shift-work day',
    blocks: [
      TemplateBlock(
        title: 'Prepare for shift',
        startTime: '22:00',
        endTime: '22:30',
        blockType: 'flexible',
        category: 'preparation',
      ),
      TemplateBlock(
        title: 'Main shift work',
        startTime: '22:40',
        endTime: '01:40',
        blockType: 'flexible',
        category: 'work',
      ),
      TemplateBlock(
        title: 'Shift break',
        startTime: '01:50',
        endTime: '02:10',
        blockType: 'fixed',
        category: 'break',
      ),
    ],
  ),
  DayTemplate(
    id: 'creative',
    name: 'Creative deep-work day',
    blocks: [
      TemplateBlock(
        title: 'Gather ideas',
        startTime: '09:00',
        endTime: '09:30',
        blockType: 'flexible',
        category: 'creative',
      ),
      TemplateBlock(
        title: 'Make something',
        startTime: '09:40',
        endTime: '11:40',
        blockType: 'flexible',
        category: 'creative',
      ),
      TemplateBlock(
        title: 'Step away',
        startTime: '11:50',
        endTime: '12:10',
        blockType: 'fixed',
        category: 'break',
      ),
      TemplateBlock(
        title: 'Review and finish',
        startTime: '13:00',
        endTime: '14:00',
        blockType: 'optional',
        category: 'creative',
      ),
    ],
  ),
];
