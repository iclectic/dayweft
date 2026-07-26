import 'package:flutter/material.dart';

class DayweftColors {
  const DayweftColors._();

  static const warmLinen = Color(0xFFFAF7F0);
  static const ink = Color(0xFF24211D);
  static const threadTeal = Color(0xFF1F8A83);
  static const saffron = Color(0xFFE2A13A);
  static const clay = Color(0xFFC86F4A);
  static const moss = Color(0xFF6F8D5D);
  static const night = Color(0xFF171A1C);
  static const nightSurface = Color(0xFF202528);
}

class DayweftTheme {
  const DayweftTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: DayweftColors.threadTeal,
      brightness: Brightness.light,
      primary: DayweftColors.threadTeal,
      secondary: DayweftColors.saffron,
      tertiary: DayweftColors.clay,
      surface: DayweftColors.warmLinen,
    );
    return _themeFrom(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: DayweftColors.threadTeal,
      brightness: Brightness.dark,
      primary: const Color(0xFF6DD6CD),
      secondary: const Color(0xFFF0C36E),
      tertiary: const Color(0xFFE58C6A),
      surface: DayweftColors.nightSurface,
    );
    return _themeFrom(scheme);
  }

  static ThemeData _themeFrom(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}

class ThreadDivider extends StatelessWidget {
  const ThreadDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.5);
    return Semantics(
      label: 'Timeline connection',
      child: CustomPaint(
        painter: _ThreadDividerPainter(color),
        child: const SizedBox(height: 20, width: double.infinity),
      ),
    );
  }
}

class _ThreadDividerPainter extends CustomPainter {
  const _ThreadDividerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.12, size.height / 2)
      ..cubicTo(
        size.width * 0.35,
        0,
        size.width * 0.65,
        size.height,
        size.width * 0.88,
        size.height / 2,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ThreadDividerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
